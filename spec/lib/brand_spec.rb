# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Brand do
  describe 'identidade textual' do
    it 'expõe o nome da Casa do Celular' do
      expect(described_class::NAME).to eq('Casa do Celular')
    end

    it 'expõe o short name CDC para o sidebar mini' do
      expect(described_class::SHORT_NAME).to eq('CDC')
    end

    it 'expõe o slogan oficial' do
      expect(described_class::TAGLINE).to eq('É barato e sempre será!')
    end

    it 'aponta o site institucional' do
      expect(described_class::WEBSITE).to eq('https://casadocelular.com.br')
    end
  end

  describe 'paleta de cores' do
    it 'tem azul primário #01297c' do
      expect(described_class::COLORS[:primary]).to eq('#01297c')
    end

    it 'tem amarelo de destaque #f7b521' do
      expect(described_class::COLORS[:secondary]).to eq('#f7b521')
    end

    it 'tem amarelo de botão / preço #e8aa20' do
      expect(described_class::COLORS[:accent]).to eq('#e8aa20')
    end

    it 'expõe todas as chaves esperadas' do
      expect(described_class::COLORS.keys).to contain_exactly(:primary, :secondary, :accent, :dark, :light)
    end
  end

  describe 'assets' do
    it 'aponta para o logo cdc-logo.png' do
      expect(described_class::ASSETS[:logo]).to eq('cdc-logo.png')
    end

    it 'aponta para o favicon cdc-favicon.png' do
      expect(described_class::ASSETS[:favicon]).to eq('cdc-favicon.png')
    end

    it 'mantém os arquivos físicos no diretório de imagens' do
      images_dir = Rails.root.join('app/assets/images')
      expect(images_dir.join(described_class::ASSETS[:logo])).to exist
      expect(images_dir.join(described_class::ASSETS[:favicon])).to exist
    end
  end

  describe 'imutabilidade' do
    it 'congela o hash de cores' do
      expect(described_class::COLORS).to be_frozen
    end

    it 'congela o hash de assets' do
      expect(described_class::ASSETS).to be_frozen
    end
  end
end
