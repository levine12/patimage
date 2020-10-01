<div class="info-section pic">    
    <div class="info-header">
        <i class="icon-medical"></i>
        <h3>Patient Picture</h3>
    </div>
<% if (patientPictureFileName) { %>
    <div class="info-body">
        <img id="myImg1" width="224" height="162"/>
    </div>
<% } else {%>
<i>NO PICTURE SUBMITTED</i>
  <% } %>

</div>

<% if (patientPictureFileName) { %>
<script type="text/javascript">
    jq(function() {
        emr.updateBreadcrumbs();

        var str = "<%= ui.resourceLink('/patient_images/') %>" + "${patientPictureFileName}";
        console.log("str: " + str);
        document.getElementById("myImg1").src = str;
    });
</script>

  <% } %>
