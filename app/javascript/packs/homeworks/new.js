import "../../plugin/jquery.steps.min.js"
import "jquery-validation"
import "bootstrap-datepicker"
// import "../../plugin/tempus-dominus"
import "../../plugin/jQuery-provider"
const tempusDominus = require("../../plugin/tempus-dominus")

function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
}


// $.fn.inputFilter = function(callback, errMsg) {
//   return this.on("input keydown keyup mousedown mouseup select contextmenu drop focusout", function(e) {
//     if (callback(this.value)) {
//       // Accepted value
//       if (["keydown","mousedown","focusout"].indexOf(e.type) >= 0){
//         $(this).removeClass("input-error");
//         this.setCustomValidity("");
//       }
//       this.oldValue = this.value;
//       this.oldSelectionStart = this.selectionStart;
//       this.oldSelectionEnd = this.selectionEnd;
//     } else if (this.hasOwnProperty("oldValue")) {
//       // Rejected value - restore the previous one
//       $(this).addClass("input-error");
//       this.setCustomValidity(errMsg);
//       this.reportValidity();
//       this.value = this.oldValue;
//       this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
//     } else {
//       // Rejected value - nothing to restore
//       this.value = "";
//     }
//   });
// };


// $('#homework_subject').numberInput(function(value) {return /^-?\d*$/.test(value); }, "Must be an integer")

$(function(){
  // $('#homework_deadline').datepicker({
  //   format: 'mm/dd/yyyy',
  //   startDate: new Date().getTime().toString(),
  //   orientation: 'bottom'
  // })

  // $('#datetimepicker1').tempusDominus({
  //   restrictions: {
  //     minDate: new Date().toDateString()
  //   },
  //   display: {
  //     theme: getCookie("theme")
  //   }
  // }).inputFormat("DD/MM/YYYY HH:mm");

  window.datetimepicker1 = new tempusDominus.TempusDominus(
    document.getElementById('datetimepicker1'),
    {
      restrictions: {
        minDate: new Date().toDateString()
      },
      display: {
        theme: getCookie("theme"),
      }
    }
  );
})

// const picker = new tempusdominus.TempusDominus(document.getElementById('homework_deadline'));



$('#new_homework').steps({
  headerTag: "h3",
  bodyTag: "stuff",
  transitionEffect: "fade",

  // enableKeyNavigation: false,
  onStepChanging: function(event, currentIndex, newIndex){
    if (currentIndex > newIndex) {
      return true;
    }
    $("#new_homework").validate({
      rules: {
        "user[email]": {
          remote: {
            url: window.location.origin + "/check-email"
          }
        },
        "user[password]": {
          minlength: 6
        },
        "user[password_confirmation]": {
          equalTo: "#user_password"
        }
      },

      messages: {
        "user[email]": "Email is already been used"
      }
    }).settings.ignore = ":disabled,:hidden";
    return $("#new_homework").valid();
  },
  onFinishing: function (event, currentIndex){
    
    console.log($("#new_homework") .valid())
    return $("#new_homework") .valid();
  },
  onFinished: function (event, currentIndex) {
    $("#new_homework").submit();
  }
})

$('div .steps').addClass("list-group list-group-horizontal")