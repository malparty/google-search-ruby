import {Offcanvas} from '../../vendor/bootstrap';

const SELECTORS = {
  offCanvasKeyword: '#offcanvasKeyword'
};

const TOGGLING_CANVAS_CLASS = 'offcanvas-toggling';

const TURBO_CLICK_EVENT = 'turbo:click';

const KEYWORD_FRAME = 'frame_keyword_show';

class KeywordCanvas {
  constructor() {
    this._setup();
  }

  // private

  _setup() {
    this._registerOnKeywordShowTurboClick();
  }

  _registerOnKeywordShowTurboClick() {
    // When a turbo:click event target the keyword_show frame, it opens the keyword canvas
    document.documentElement.addEventListener(TURBO_CLICK_EVENT, (event) => {
      if (event.target.dataset.turboFrame === KEYWORD_FRAME) {
        const canvasElement = document.querySelector(SELECTORS.offCanvasKeyword);
        if (!canvasElement.classList.contains(TOGGLING_CANVAS_CLASS)) {
          new Offcanvas(SELECTORS.offCanvasKeyword, {backdrop: false}).show();
        }
      }
    }, false);
  }
}

export default KeywordCanvas;
