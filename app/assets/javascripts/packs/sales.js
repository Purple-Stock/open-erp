$(document).on('turbo:load').ready( function () {
  // $('#sales-ajax').dataTable({
  //     type: "GET",
  //     ajax: '/sales_defer',
  //     deferRender: true,
  //     dataSrc: function (json) {
  //         json.recordsTotal = json.meta.recordsTotal;
  //         json.recordsFiltered = json.meta.recordsFiltered;
  //     },
  //     columns: [
  //         { title: "Cliente", searchable: true, data: 'attributes.name' },
  //         { title: "Desconto em R$", searchable: false, data: 'attributes.discount', orderable: false },
  //         { title: "Online", data: 'attributes.online', searchable: false },
  //         { title: "Código Pedido Online", searchable: true, data: 'attributes.order_code' },
  //         { title: "Valor", data: 'attributes.value', searchable: false,  },
  //         { title: "Divulgação", data: 'attributes.disclosure', searchable: false, orderable: false },
  //         { title: "Troca", data: 'attributes.exchange', searchable: false, orderable: false },
  //         { title: "Data de criação", data: 'attributes.created_at', searchable: true },
  //         { title: "Ações", data: 'attributes.id', render: function(id){
  //             return '<a class="btn btn-default btn-xs" href="/sales/'+ id + '">Ver</a><a class="btn btn-default btn-xs" href="/sales/'+ id + '/edit">Editar</a><a data-confirm="Você tem certeza?" data-method="delete" rel="nofollow" class="btn btn-danger btn-xs" href="/sales/'+ id + '">Deletar</a>';
  //         }}
  //     ],
  //     serverSide: true,
  //     "language": {
  //         "url": "https://cdn.datatables.net/plug-ins/1.10.12/i18n/Portuguese-Brasil.json"
  //     },
  //     columnDefs: [
  //         { type: 'formatted-num', targets: 0 }
  //     ],
  //     "order": [[ 3, "desc" ]],
  //     responsive: true,
  //     stateSave: true
  // });
});