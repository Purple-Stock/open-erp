$(document).ready(function (){
    let chartDomElement = document.getElementById('chartjs-bar')
    let options = {
        maintainAspectRatio: false,
        responsive: true,
        aspectRatio: 2,
        scales: {
            y: {
                beginAtZero: true,
                stacked: false,
                grid: {
                    display: true,
                    color: "rgba(0,0,0,0.1)"
                }
            },
            x: {
                stacked: false,
                grid: {
                    display: false
                }
            }
        },
        plugins: {
            legend: {
                position: 'top',
            },
            title: {
                display: true,
                text: 'Quantidade vendida nos últimos 15 dias'
            }
        }
    };

    if(chartDomElement !== null) {
        $.ajax({
            url: 'bling_order_item_histories/day_quantities', 
            success: function(result){
                new Chart(
                    chartDomElement,
                    {
                        type: 'bar',
                        options: options,
                        data: {
                            labels: result.map(row => row.day),
                            datasets: [
                                {
                                    label: 'Quantidade vendida',
                                    data: result.map(row => row.quantity),
                                    backgroundColor: 'rgba(54, 162, 235, 0.8)'
                                }
                            ]
                        }
                    }
                )
            }
        });
    }
})
