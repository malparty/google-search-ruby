import CSVUploadForm from '../../components/CSVUploadForm';

const SELECTORS = {
  screen: '.screen-keywords',
  csvUploadForm: '#new_CSVUploadForm'
};

class KeywordsScreen {
  constructor() {
    this.csvUploadForm = document.querySelector(SELECTORS.csvUploadForm);

    this._setup();
  }

  // private

  _setup() {
    new CSVUploadForm(this.csvUploadForm);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const isKeywordsScreen = document.querySelector(SELECTORS.screen) !== null;

  if (isKeywordsScreen) {
    new KeywordsScreen();
  }
});
