function passVisibility() {
   var x = document.getElementById("password");
   if (x.type === "password") {
      x.type = "text";
   }
   else {
      x.type = "password";
   }
}

<script>
  var today = new Date();
  var twoWeeksLater = new Date(today.getTime() + 14 * 24 * 60 * 60 * 1000);
  var minDate = twoWeeksLater.toISOString().split('T')[0];
  document.getElementById("end_date").min = minDate;
</script>




