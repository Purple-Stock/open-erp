$(document).ready(function (){
    function plotChartBar() {
        let chartCanvasDomElement = $('#canceled-revenue-chart');
        let revenue = $('#canceled_revenue').val();
        let data = JSON.parse(revenue);
        let cfg = {
            type: 'bar',
            options: {
                maintainAspectRatio: false,
                aspectRatio: 1
            },
            data: {
                datasets: [{
                    label: 'Shein',
                    data: data,
                    parsing: {
                        yAxisKey: 'shein'
                    }
                }, {
                    label: 'Shopee',
                    data: data,
                    parsing: {
                        yAxisKey: 'shopee'
                    }
                }, {
                    label: 'Simple 7',
                    data: data,
                    parsing: {
                        yAxisKey: 'simple_7'
                    }
                },
                    {
                        label: 'Mercado Livre',
                        data: data,
                        parsing: {
                            yAxisKey: 'mercado_livre'
                        }
                    }, {
                        label: 'Total',
                        data: data,
                        parsing: {
                            yAxisKey: 'total'
                        }
                    }]
            },
        };
        new Chart(chartCanvasDomElement, cfg);
    }

    plotChartBar();
})