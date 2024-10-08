document.addEventListener('turbolinks:load', function() {
  let chartJsBarDailyRevenueDomElement = $('#chartjs-bar-daily-revenue');
  
  function plotDailyRevenueChartBar() {
    let dailyRevenue = $('#daily_revenue').val();
    if(typeof dailyRevenue === 'undefined'){
      return;
    }
    let data = JSON.parse(dailyRevenue);
    let cfg = {
      type: 'bar',
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { position: 'top' },
          title: {
            display: true,
            text: 'Faturamento Diário por Loja'
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Faturamento (R$)'
            }
          },
          x: {
            ticks: {
              maxRotation: 45,
              minRotation: 45
            }
          }
        },
        animation: { duration: 0 }
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
          },
          type: 'line'
        }]
      },
    };
    new Chart(chartJsBarDailyRevenueDomElement, cfg);
  }

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        plotDailyRevenueChartBar();
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });

  if (chartJsBarDailyRevenueDomElement.length) {
    observer.observe(chartJsBarDailyRevenueDomElement[0]);
  }
});
