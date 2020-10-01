<%
 ui.decorateWith("appui", "standardEmrPage")
ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
%>

<script type="text/javascript">
            //var OPENMRS_CONTEXT_PATH = 'openmrs';
            window.sessionContext = window.sessionContext || {
                locale: "en_GB"
            };
            window.translations = window.translations || {};
</script>

<script type="text/javascript">
   var breadcrumbs = [

       { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "Delete Old Patient Images"}
    ];

</script>

<script type="text/javascript">
var deleteFileNames = "";
  
jq=jQuery;
jq(function() { 
     jq('#patientImageTable').dataTable({
            "aaSorting": [],
            "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true
        });

    jq("#deleteButton").click(function() {
        console.log(deleteFileNames);
        jq( "#dialog-confirm-deletePatientImageFiles" ).dialog( "open" );
    });

jq( "#dialog-confirm-deletePatientImageFiles" ).dialog({
    autoOpen: false,
      resizable: false,
      height: "auto",
      width: 400,
      modal: true,
      buttons: {
        "Delete Patient Image Files": function() {
            jq(this).dialog("close");
            callbackDeletePatientImageFiles(true);
        },
        Cancel: function() {
            jq(this).dialog("close");
            callbackDeletePatientImageFiles(false);
        }
      }
    });
});

function deletePatientImageFile(th,fname) {
    //var a = jq(th).parent().parent().css( "background-color", "red" );; 
    if (jq(th).parent().parent().hasClass( "selected" )) {
        jq(th).parent().parent().removeClass('selected');
        deleteFileNames = deleteFileNames.replace("%" + fname + "%",'');
    } else {
        jq(th).parent().parent().addClass('selected');
        console.log("Delete File : " + fname);
        deleteFileNames += "%" + fname + "%";
    };
}

           function callbackDeletePatientImageFiles(value) {
                event.stopPropagation();
                if (!value) {
                    return;
                }
                jq("#fileList").val(deleteFileNames);
                jq("#deletePatientImageFilesForm").submit();
            }

</script>

<table id="patientImageTable"  class="patientImageTablec" border="1" class="display" cellspacing="0" width="50%">
<thead>
<th>File Name</th><th>Last Modification Date</th><th>Delete</th>
</thead>
<tbody >
    <% if (filesInfos) { %>
        <% filesInfos.each { fileInfo ->%>
            <tr>
                <td>${fileInfo.fileName}</td><td>${fileInfo.fileModifyDate}</td>
                <td><em class="icon-trash delete-action" class="selected"  onclick="deletePatientImageFile(this,'${fileInfo.fileName}')"</em></td>
            </tr>
        <% } %>
    <% } else {%>
        <td></td><td></td><td></td>
    <% } %>
</tbody>
</table>

<button id="deleteButton" type="button">Delete Patient Images</button>

<div id="dialog-confirm-deletePatientImageFiles" title="Delete Selected Patient Image Files?">
  <p><span class="ui-icon ui-icon-alert" style="float:left; margin:12px 12px 20px 0;"></span>These patient image files will be permanently deleted and cannot be recovered. Are you sure?</p>
</div>

<form id="deletePatientImageFilesForm" method="post">
    <input type="hidden" id="fileList" name="fileList">
</form>

<script id="breadcrumb-template" type="text/template">
    <li>
        {{ if (!first) { }}
        <i class="icon-chevron-right link"></i>
        {{ } }}
        {{ if (!last && breadcrumb.link) { }}
        <a href="{{= breadcrumb.link }}">
        {{ } }}
        {{ if (breadcrumb.icon) { }}
        <i class="{{= breadcrumb.icon }} small"></i>
        {{ } }}
        {{ if (breadcrumb.label) { }}
        {{= breadcrumb.label }}
        {{ } }}
        {{ if (!last && breadcrumb.link) { }}
        </a>
        {{ } }}
    </li>
</script> 
