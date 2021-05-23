$(document).on('turbo:load').ready( function () {
    $('#sale_customer_id').select2();
    $('.form-control-sm').select2();
    $( ".add_fields" ).click(function() {
        setTimeout(function(){$('.form-control-sm').select2(); }, 1);
    });


    onScan.attachTo(document, {
        suffixKeyCodes: [13], // enter-key expected at the end of a scan
        // onKeyProcess: function(sChar, oEvent){
        //     console.log(sChar);
        //     console.log(oEvent);
        //     console.log(oEvent.keyCode);
        // },
        keyCodeMapper: function(oEvent) {
            // Look for special keycodes or other event properties specific to
            // your scanner
            if (oEvent.which == 219) {
                return '{';
            }else if (oEvent.which == 221) {
                return '}';
            }else if (oEvent.which == 186) {
                return ':';            
            }else if (oEvent.which == 188) {
                return ',';
            }else if (oEvent.which == 222) {
                return '"';            
            }else if (oEvent.which == 189) {
                return '_';
            }else if (oEvent.which == 32) {
                return ' ';
            }else if (oEvent.which == 190) {
                return '.';
            }else{
                // Fall back to the default decoder in all other cases
                return onScan.decodeKeyEvent(oEvent);
            }
        },
        onScan: function(sCode) { // Alternative to document.addEventListener('scan')
            // console.log(sCode);
            fetchProducts(JSON.parse(sCode));
        }
    });

    var product_data;

    function fetchProducts(custom_qr) {
        fetch('/api/v1/products/' + custom_qr.custom_id).then(function (res) {
            if (res.ok) {
                return res.json();
            }
        }).then(function (data) {
            product_data = data
            document.querySelector(".links > a").click();
        }).catch(function (err) {
            return console.log(err);
        });
    }

    $('.links').on('cocoon:after-insert', function(e, insertedItem, originalEvent) {
        insertedItem[0].querySelector('.form-control-sm').value = product_data.id;
        insertedItem[0].querySelectorAll('input')[0].value = 1;
        insertedItem[0].querySelectorAll('input')[1].value = product_data.price;
    });

    $('#sales-ajax').dataTable({
        ajax: '/sales_defer',
        deferRender: true,
        dataSrc: function (json) {
            json.recordsTotal = json.meta.recordsTotal;
            json.recordsFiltered = json.meta.recordsFiltered;
        },
        columns: [
            { title: "Cliente", searchable: true, data: 'attributes.name' },
            { title: "Desconto em R$", searchable: false, data: 'attributes.discount', orderable: false },
            { title: "Online", data: 'attributes.online', searchable: false },
            { title: "Código Pedido Online", searchable: true, data: 'attributes.order_code' },
            { title: "Valor", data: 'attributes.value', searchable: false,  },
            { title: "Divulgação", data: 'attributes.disclosure', searchable: false, orderable: false },
            { title: "Troca", data: 'attributes.exchange', searchable: false, orderable: false },
            { title: "Data de criação", data: 'attributes.created_at', searchable: true },
            { title: "Ações", data: 'attributes.id', render: function(id){
                return '<a class="btn btn-default btn-xs" href="/sales/'+ id + '">Ver</a><a class="btn btn-default btn-xs" href="/sales/'+ id + '/edit">Editar</a><a data-confirm="Você tem certeza?" data-method="delete" rel="nofollow" class="btn btn-danger btn-xs" href="/sales/'+ id + '">Deletar</a>';               
            }}
        ],
        serverSide: true,
        "language": {
            "url": "https://cdn.datatables.net/plug-ins/1.10.12/i18n/Portuguese-Brasil.json"
        },
        columnDefs: [
            { type: 'formatted-num', targets: 0 }
        ],
        "order": [[ 3, "desc" ]],
        responsive: true,
        stateSave: true
    });

});
function fetchSaleProducts(element) {
    const row = element.parentElement.parentElement.parentElement;
    const quantity = row.querySelector('.quantity').value;
    id = row.querySelector('.product-id').value;
    fetch('/api/v1/sale_products/' + id).then(function (res) {
        if (res.ok) {
            return res.json();
        }
    }).then(function (data) {
        row.querySelector('.product-value').value = (data.price * parseInt(quantity)).toFixed(2);
    }).catch(function (err) {
        return console.log(err);
    });
}