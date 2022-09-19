---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

# LAPD

<form id='lapdSearch' novalidate class="usa-form">
  <legend class="usa-legend">
    Look up LAPD officers by serial number.
  </legend>
  <div id="validation-alert" class="usa-alert usa-alert--info usa-alert--slim">
    <div class="usa-alert__body">
      <p class="error usa-alert__text" aria-live="polite">
        Serial numbers are 5 digits.
      </p>
    </div>
  </div>

  <noscript>
    <div class="usa-alert usa-alert--error usa-alert--slim">
      <div class="usa-alert__body">
        <p class="usa-alert__text">
          Enable JavaScript to use search.
        </p>
      </div>
    </div>
  </noscript>

      </p>
    </div>
  </div>
  <label class="usa-label" for="serial-number">Serial number</label>
  <input
    class="usa-input"
    id="serial-number"
    name="serial-number"
    type="text"
    autocomplete="off"
    autocapitalize="off"
    autocorrect="off"
    autofocus="true"
    required="required"
    size=6
    placeholder="23506"
    pattern="\d{5}"
    list="lapd-serial-numbers"
  />

  <datalist id="lapd-serial-numbers">
    {% for cop in site.data['us']['ca']['police']['los_angeles']['cops'] %}
      <option value="{{ cop['SerialNo'] }}"/>
    {% endfor %}
  </datalist>

  <input class="usa-button" type="submit" disabled value="Find Officer" />
</form>

<script>
  const form = document.getElementById('lapdSearch')
  const serialNumberField = form.querySelector('input#serial-number')
  const validationAlert = document.getElementById('validation-alert')
  const searchButton = form.querySelector('input[type="submit"]')

  function findLapdCop(event) {
    event.preventDefault()

    if (serialNumberField.validity.valid) {
      const serialNumber = event.target.querySelector('#serial-number').value
      const path = `/us/ca/police/los_angeles/${serialNumber}`
      window.location.assign(path)
    }
  }

  function validateSerialNumber(event) {
    if (serialNumberField.validity.valid) {
      validationAlert.classList.replace('usa-alert--info', 'usa-alert--success')
      searchButton.disabled = false
    } else {
      validationAlert.classList.replace('usa-alert--success', 'usa-alert--info')
      searchButton.disabled = true
    }
  }

  form.addEventListener('submit', findLapdCop)
  serialNumberField.addEventListener('input', validateSerialNumber)
</script>
