$(document).ready( function () {
  $('#product_category_id').select2();
  // $('#product-ajax').dataTable({
  //   ajax: {
  //   url: '/products_defer',
  //   deferRender: true,
  //   dataSrc: function (json) {
  //       json.recordsTotal = json.meta.recordsTotal;
  //       json.recordsFiltered = json.meta.recordsFiltered;
  //       return json.data
  //   }
  //   },
  //   serverSide: true,
  //   columns: [
  //       { title: "Codigo Produto", data: 'attributes.custom_id' },
  //       { title: "SKU", data: 'attributes.sku', "searchable": false, "orderable": false },
  //       { title: "Foto", data: 'attributes.image_url', "orderable": false, "searchable": false, render: function(image_url){
  //           return '<img src="' + image_url + '"width="250px" height="163px">';
  //       	}
  //       },
  //       { title: "Preço", data: 'attributes.price', "searchable": false, "orderable": false },
  //       { title: "Nome", data: 'attributes.name' },
  //       { title: "Entrada", data: 'attributes.count_purchase_product', "orderable": false, "searchable": false },
  //       { title: "Saída", data: 'attributes.count_sale_product', "orderable": false, "searchable": false },
  //       { title: "Saldo", data: 'attributes.balance', "orderable": false, "searchable": false },
  //       { title: "Categoria", data: 'attributes.category', "orderable": false, "searchable": false },
  //       { title: "Ativo", data: 'attributes.active', "searchable": false, "orderable": false },
  //       { title: "Ações", data: 'attributes.id', "searchable": false, "orderable": false,  render: function(id){
  //           let html = '<a class="btn btn-default btn-xs" href="/products/'+ id + '">Ver</a><a class="btn btn-default btn-xs" href="/products/'+ id + '/edit">Editar</a><a data-confirm="Você tem certeza?" data-method="delete" rel="nofollow" class="btn btn-danger btn-xs" href="/products/'+ id + '">Deletar</a>';
  //           html += '<a class="btn btn-default btn-xs" href="/products/'+ id +'/duplicate">Duplicar</a>';
  //           return html;
  //       }}
  //   ],
  //   "language": {
  //       "url": "https://cdn.datatables.net/plug-ins/1.10.12/i18n/Portuguese-Brasil.json"
  //   },
  //   columnDefs: [
  //       { type: 'formatted-num', targets: 0 }
  //   ],
  //   "order": [[ 0, "desc" ]],
  //   responsive: true,
  //   stateSave: false
  // });
} );