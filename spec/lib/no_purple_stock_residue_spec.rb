# frozen_string_literal: true

require 'rails_helper'

# Sentinela de rebranding: garante que nenhum arquivo do app, config ou public
# carrega referências textuais ou visuais ao branding Purple Stock antigo.
# Falhar este spec é o sinal de que algum merge do upstream trouxe branding velho.
RSpec.describe 'rebranding residue check' do
  ROOTS = %w[app config public lib].freeze
  FORBIDDEN_PATTERNS = [
    /purple\s?stock/i,
    /purplestock\.com\.br/i,
    %r{purple-stock\.s3-sa-east-1\.amazonaws\.com}i,
    /favicon_purple/i,
    /purple-logo\.png/i
  ].freeze

  ALLOWLIST_PATHS = [
    'CLAUDE.md',
    'README.md',
    'README-english-version.MD',
    'Gemfile',
    'Gemfile.lock'
  ].freeze

  def candidate_files
    files = []
    ROOTS.each do |root|
      Dir.glob(Rails.root.join(root, '**/*')).each do |path|
        next unless File.file?(path)
        next if path.match?(%r{/(node_modules|vendor|tmp|log|storage|spec)/})
        next if File.binary?(path) rescue false

        files << path
      end
    end
    files
  end

  it 'não contém termos de branding Purple Stock no app/config/public/lib' do
    offending = []

    candidate_files.each do |path|
      relative = Pathname.new(path).relative_path_from(Rails.root).to_s
      next if ALLOWLIST_PATHS.include?(relative)

      content = File.read(path, mode: 'r:bom|utf-8')
      FORBIDDEN_PATTERNS.each do |pattern|
        offending << "#{relative} :: #{pattern.inspect}" if content.match?(pattern)
      end
    rescue ArgumentError, Encoding::InvalidByteSequenceError
      next # arquivos binários ou com encoding ruim — ignora
    end

    expect(offending).to be_empty, lambda {
      "Branding antigo encontrado em #{offending.size} ocorrência(s):\n  - #{offending.join("\n  - ")}"
    }
  end
end
