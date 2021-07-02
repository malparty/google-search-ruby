document.addEventListener('DOMContentLoaded', (event) => {
  // Csv File upload form - submit when file selected
  document.getElementById('csv_upload_form_file').onchange = () => {
    document.getElementById('new_CSVUploadForm').submit();
  };
});
