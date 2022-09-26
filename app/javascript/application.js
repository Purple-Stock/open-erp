// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Core libraries
import "@hotwired/turbo-rails"

// require("@rails/ujs").start()
// require("@rails/activestorage").start()

require("./channels")
import "./controllers"

// Application
require("./app").start()

// jQuery (as a read only property so browser extensions can't clobber it)
const jquery = require("jquery")
window.$ = window.jQuery = jquery
// const descriptor = { value: jquery, writable: false, configurable: false }
// Object.defineProperties(window, { $: descriptor, jQuery: descriptor })

// App libraries
require("bootstrap")
require("jquery.nicescroll")

require("select2")
require("cleave.js")
require("waypoints/lib/noframework.waypoints")
require("waypoints/lib/shortcuts/infinite")
require("@nathanvda/cocoon")
// require("datatables/media/js/jquery.dataTables.min")
// require("datatables.net")
// require( 'datatables.net' )( window, $ );
// require( 'datatables.net-bs4' )( window, $ );
// require("datatables.net-select-bs4")

window.iziToast = require("izitoast")

// Stisla
require("./vendors/stisla/stisla")
require("./vendors/stisla/scripts")

import flatpickr from "flatpickr";
import {Portuguese} from "flatpickr/dist/l10n/pt"

flatpickr.localize(Portuguese); // default locale is now Portuguese

import Swal from 'sweetalert2';


Turbo.setConfirmMethod((message, element) => {
    console.log(message, element)

    // let dialog = document.getElementById("turbo-confirm")
    // dialog.querySelector("p").textContent = message
    // dialog.showModal()

    return new Promise((resolve, reject) => {
        Swal.fire({
            title: message,
            text: "Você não poderá reverter isso!",
            icon: 'warning',
            type: 'warning',
            confirmButtonText: 'OK',
            confirmButtonColor: '#2acbb3',
            cancelButtonText: 'Cancelar',
            cancelButtonColor: '#d33',
            showCancelButton: true,

        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire(
                    'Removido!',
                    'Dados removidos com sucesso.',
                    'success'
                )
                resolve(true)
                return true;
            } else if (result.isDenied) {
                Swal.fire('As alterações não foram são salvas', '', 'info')
                reject(true)
                return false;
            }
        })
    })
})
// $(document).ready( function () {
document.addEventListener("turbo:load", () => {
    $('#list').select2();
    $('.select2-list').select2();
    flatpickr(".flatpick-input-date", {dateFormat: "d/m/Y", altInput: true, altFormat: "d/m/Y",})
    flatpickr(".flatpick-input-datetime", {dateFormat: "d/m/Y H:i", altInput: true, altFormat: "d/m/Y H:i",})


    // $('#myTable').dataTable();


    // $('#product-ajax').dataTable(    );
    // $('#stockTable').dataTable({
    //     "language": {
    //         "url": "https://cdn.datatables.net/plug-ins/1.10.12/i18n/Portuguese-Brasil.json"
    //     },
    //     columnDefs: [
    //         {type: 'formatted-num', targets: 0}
    //     ],
    //     "order": [[0, "desc"]],
    //     responsive: true,
    //     stateSave: true
    // });
    //
    // jQuery.extend(jQuery.fn.dataTableExt.oSort, {
    //     "formatted-num-pre": function (a) {
    //         a = (a === "-" || a === "") ? 0 : a.replace(/[^\d\-\.]/g, "");
    //         return parseFloat(a);
    //     },
    //
    //     "formatted-num-asc": function (a, b) {
    //         return a - b;
    //     },
    //
    //     "formatted-num-desc": function (a, b) {
    //         return b - a;
    //     }
    // });
    //
    // jQuery.extend(jQuery.fn.dataTableExt.oSort, {
    //     "date-uk-pre": function (a) {
    //         if (a == null || a == "") {
    //             return 0;
    //         }
    //         var ukDatea = a.split('/');
    //         return (ukDatea[2] + ukDatea[1] + ukDatea[0]) * 1;
    //     },
    //
    //     "date-uk-asc": function (a, b) {
    //         return ((a < b) ? -1 : ((a > b) ? 1 : 0));
    //     },
    //
    //     "date-uk-desc": function (a, b) {
    //         return ((a < b) ? 1 : ((a > b) ? -1 : 0));
    //     }
    // });
});
