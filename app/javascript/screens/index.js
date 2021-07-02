document.addEventListener("DOMContentLoaded", (event) => {
  // Csv File upload form - submit when file selected
  document.getElementById('csv_upload_form_').onchange = () => {
    document.getElementById('new_CSVUploadForm').submit()
  }
});
