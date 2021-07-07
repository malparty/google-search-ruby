import {XMLHttpRequest} from 'xmlhttprequest';

export class AjaxRequest {
  constructor(url, method, success) {
    this.url = url;
    this.method = method;

    this.errorCallback = () => {
    };

    if (success == null) {
      this.successCallback = success;
    } else {
      this.successCallback = () => {
      };
    }

    this._sendRequest();
  }

  loadResultIn(elementId) {
    this.loadInElementId = elementId;

    return this;
  }

  error(errorCallback) {
    this.errorCallback = errorCallback;

    return this;
  }

  // private

  _sendRequest() {
    const xhr = new XMLHttpRequest();

    this._addErrorListeners(xhr);

    xhr.onreadystatechange = () => {
      if (xhr.readyState === 4) {
        this._onReadyStateDone(xhr);
      }
    };

    xhr.open(this.method, this.url);
    xhr.send();
  };

  _onReadyStateDone(xhr) {
    if (xhr.status >= 200 && xhr.status < 300) {
      this._onSuccess(xhr);
    } else {
      this.errorCallback(xhr);
    }
  }

  _onSuccess(xhr) {
    this.result = xhr.response;

    if (this.loadInElementId != null) {
      document.getElementById(this.elementId).innerHTML = this.result;
    }

    this.successCallback(xhr.response);
  }

  _addErrorListeners(xhr) {
    xhr.addEventListener('error', this.errorCallback);
    xhr.addEventListener('abort', this.errorCallback);
    xhr.addEventListener('timeout', this.errorCallback);
  }
}
