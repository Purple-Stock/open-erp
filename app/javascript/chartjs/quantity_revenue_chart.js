$(document).ready(function (){
    let charDomElement = document.getElementById('chartjs-bar')
    let options = {
        maintainAspectRatio: false,
        aspectRatio: 1,
        scales: {
            y: {
                stacked: false,
                grid: {
                    display: true,
                    color: "rgba(255,99,132,0.2)"
                }
            },
            x: {
                stacked: false,
                grid: {
                    display: false
                }
            }
        }
    };

    if(charDomElement !== null) {
        $.ajax({url: 'bling_order_item_histories/day_quantities', success: function(result){
                new Chart(
                    document.getElementById('chartjs-bar'),
                    {
                        type: 'bar',
                        options: options,
                        data: {
                            labels: result.map(row => row.day),
                            datasets: [
                                {
                                    label: 'Quantidade vendida nos últimos 15 dias',
                                    data: result.map(row => row.quantity)
                                }
                            ]
                        }
                    }
                )
            }
        }
        )

    }
})