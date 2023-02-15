$(document).on('turbo:load').ready( function () {
    $('#sale_customer_id').select2();
    $('.form-control-sm').select2();
    $( ".add_fields" ).click(function() {
        setTimeout(function(){$('.form-control-sm').select2(); }, 1);
    });

    onScan.attachTo(document, {
        suffixKeyCodes: [13], // enter-key expected at the end of a scan
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
            fetchProducts(JSON.parse(sCode));
        }
    });

    var product_data;

    function fetchProducts(custom_qr) {
        fetch('/api/v1/products/' + custom_qr.custom_id).then(function (response) {
            if (response.ok) {
                return response.json();
            }
        }).then(function (data) {
            product_data = data
            document.querySelector(".links > a").click();
        }).catch(function (error) {
            return console.log(error);
        });
    }

    $('.links').on('cocoon:after-insert', function(e, insertedItem, originalEvent) {
        insertedItem[0].querySelector('.form-control-sm').value = product_data.id;
        insertedItem[0].querySelectorAll('input')[0].value = 1;
        insertedItem[0].querySelectorAll('input')[1].value = product_data.price;
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
    }).catch(function (error) {
        return console.log(error);
    });
}