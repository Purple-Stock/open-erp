# frozen_string_literal: true

# Check the doc at https://github.com/lucascaton/enumerate_it#using-enumerations
class BlingOrderItemStore < EnumerateIt::Base
  associate_values(
    :all => '99',
    'Shein' => '204219105',
    'Shopee' => '203737982',
    'Simplo 7' => '203467890',
    'Mercado Livre' => '204061683',
    'Nuvem Shop' => '204796870',
    'Feira Da Madrugada' => '204824954',
    'Sem Loja' => '0'
  )
end
