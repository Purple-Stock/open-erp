document.addEventListener('turbolinks:load', function() {
  function plotChartBar() {
    let chartCanvasDomElement = $('#canceled-revenue-chart');
    let revenue = $('#canceled_revenue').val();
    if (typeof revenue === 'undefined'){
      return;
    }
    let data = JSON.parse(revenue);
    let cfg = {
      type: 'bar',
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { position: 'top' },
          title: {
            display: true,
            text: 'Custo de Oportunidade dos Pedidos Cancelados por Loja'
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Valor (R$)'
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
    new Chart(chartCanvasDomElement, cfg);
  }

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        plotChartBar();
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });

  let chartElement = $('#canceled-revenue-chart');
  if (chartElement.length) {
    observer.observe(chartElement[0]);
  }
});
