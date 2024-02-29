$(document).ready(function (){
    let chartJsBarDailyRevenueDomElement = $('#chartjs-bar-daily-revenue');
    function plotDailyRevenueChartBar() {
        dailyRevenueChartBar = new Chart(chartJsBarDailyRevenueDomElement, cfg);
    }
    let dailyRevenue = $('#daily_revenue').val();
    if(typeof dailyRevenue === 'undefined'){
        return;
    }
    let data = JSON.parse(dailyRevenue);
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
            }, 
            {
                label: 'Shopee',
                data: data,
                parsing: {
                    yAxisKey: 'shopee'
                }
            }, 
            {
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
            }, 
            {
                label: 'Feira da Madrugada',
                data: data,
                parsing: {
                    yAxisKey: 'feira_madrugada'
                }
            }, 
            {
                label: 'Nuvem Shop',
                data: data,
                parsing: {
                    yAxisKey: 'nuvem_shop'
                }
            }, 
            {
                label: 'Total',
                data: data,
                parsing: {
                    yAxisKey: 'total'
                }
            }]
        },
    };


    let dailyRevenueChartBar;

    plotDailyRevenueChartBar();
})