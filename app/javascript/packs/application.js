// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Core libraries
require("@hotwired/turbo")
require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

// jQuery (as a read only property so browser extensions can't clobber it)
const jquery = require("jquery")
const descriptor = { value: jquery, writable: false, configurable: false }
Object.defineProperties(window, { $: descriptor, jQuery: descriptor })

// App libraries
require("bootstrap")
require("jquery.nicescroll")

require("select2")
require("cleave.js")
require("waypoints/lib/noframework.waypoints")
require("waypoints/lib/shortcuts/infinite")
require("@nathanvda/cocoon")

window.iziToast = require("izitoast")

// Stisla
require("vendors/stisla/stisla")
require("vendors/stisla/scripts")

// Application
require("app").start()

import "controllers"

$(document).ready( function () {
  $('#list').select2();

  $('#stockTable').dataTable( {
  "language": {
          "url": "https://cdn.datatables.net/plug-ins/1.10.12/i18n/Portuguese-Brasil.json"
      },
       columnDefs: [
       { type: 'formatted-num', targets: 0 }
    ],
  "order": [[ 0, "desc" ]],
  responsive: true,
     stateSave: true
  } );

jQuery.extend( jQuery.fn.dataTableExt.oSort, {
    "formatted-num-pre": function ( a ) {
        a = (a === "-" || a === "") ? 0 : a.replace( /[^\d\-\.]/g, "" );
        return parseFloat( a );
    },
 
    "formatted-num-asc": function ( a, b ) {
        return a - b;
    },
 
    "formatted-num-desc": function ( a, b ) {
        return b - a;
    }
} );

jQuery.extend( jQuery.fn.dataTableExt.oSort, {
    "date-uk-pre": function ( a ) {
        if (a == null || a == "") {
            return 0;
        }
        var ukDatea = a.split('/');
        return (ukDatea[2] + ukDatea[1] + ukDatea[0]) * 1;
    },
 
    "date-uk-asc": function ( a, b ) {
        return ((a < b) ? -1 : ((a > b) ? 1 : 0));
    },
 
    "date-uk-desc": function ( a, b ) {
        return ((a < b) ? 1 : ((a > b) ? -1 : 0));
    }
} );
} );
