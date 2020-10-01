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
        { label:"${patient.familyName}, ${patient.givenName}",
          link: '/' + OPENMRS_CONTEXT_PATH + '/coreapps/clinicianfacing/patient.page?patientId=${patient.patientId}&app=pih.app.clinicianDashboard' },
        { label: "Upload Patient Images"}
    ];
</script>

<style>
    #progress-bar {
        margin: 8px;
        width: auto;
        background-color: lightgray;
    }

    #progress {
        width: 1%;
        height: 30px;
        background-color: green;
        text-align: center;
        color: white;
    }
</style>

<label for="file-input">File (jpg,gif,png):</label>
<input id="file-input" type="file" accept=".gif, .jpg, .png" oninput="clearProgressBar()">

<button id="send">Send</button>

<div id="progress-bar">
    <div id="progress"></div>
</div>

<script>
    const sendButton = document.querySelector('#send');
    sendButton.addEventListener(
        'click',
        function (e) {
            console.log("Send button clicked");
            uploadFile();
        },
        false);

    const fileInput = document.querySelector('#file-input');
    function clearProgressBar() {
            updateProgress(0);
    }

    function uploadFile() {
        var file = fileInput.files[0];
            if(file){
                console.log(file.name, " selected.");
                initUpload(file);
            } else {
                console.log("Please select the file.")
            }
    }

    function initUpload(file) {
        var xhr = new XMLHttpRequest();
        var uri = "uploadPatimage.form";
        xhr.open("POST", uri);
        xhr.overrideMimeType('text/plain; charset=x-user-defined-binary');

        xhr.upload.onprogress = function(e) {
            var percentComplete = Math.ceil((e.loaded / e.total) * 100);
            console.log(percentComplete);
            updateProgress(percentComplete);
        };

        xhr.onreadystatechange = function() {
            console.log("----- readyState changed -----");
            console.log("readyState :", xhr.readyState);
            console.log("Response :", xhr.responseText);
            if (xhr.readyState === 4) {
                console.log("Upload finish");

                var jsonResponse = this.responseText;
                location.reload(true)

            }
        };

var parts = location.search.substring(1).split('&');
var patientId = parts[0].split('=')[1];

        var formData = new FormData();
        var reader = new FileReader();
        reader.onload = (function (e) {
            var previewFile = e.target.result;
            formData.append("filename", file.name);
            formData.append("file", previewFile);
            formData.append("patientId", patientId);
            var result = xhr.send(formData);
        });
        reader.readAsDataURL(file);

    }

    var elem = document.getElementById("progress");

    function updateProgress(progress) {
        elem.style.width = progress + '%';
        elem.innerHTML = progress + '%';
    }

</script>









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



