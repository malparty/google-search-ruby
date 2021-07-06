$(() => {
  // Csv File upload form - submit when file selected
  $('#csv_upload_form_file').on('change', () => {
    $('#new_CSVUploadForm').submit();
  });
});
