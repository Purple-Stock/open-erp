# frozen_string_literal: true

# Identidade visual e textual da aplicação.
# Centraliza nome, slogan, paleta e URLs institucionais para que views,
# mailers e specs leiam de um único lugar.
module Brand
  NAME       = 'Casa do Celular'
  SHORT_NAME = 'CDC'
  TAGLINE    = 'É barato e sempre será!'
  WEBSITE    = 'https://casadocelular.com.br'
  EMAIL      = 'contato@casadocelular.com.br'

  COLORS = {
    primary:   '#01297c', # Azul institucional
    secondary: '#f7b521', # Amarelo destaque (hover)
    accent:    '#e8aa20', # Amarelo botão / preço
    dark:      '#000000',
    light:     '#ffffff'
  }.freeze

  ASSETS = {
    logo:    'cdc-logo.png',
    favicon: 'cdc-favicon.png'
  }.freeze
end
