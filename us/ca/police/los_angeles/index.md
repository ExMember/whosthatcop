---
layout: home
---

# Los Angeles Police Department (LAPD)

<form id='lapdSearch' novalidate class="usa-form">
  <legend class="usa-legend">
    Get information about LAPD officers.
  </legend>
  <noscript>
    <div class="usa-alert usa-alert--error usa-alert--slim">
      <div class="usa-alert__body">
        <p class="usa-alert__text">
          Enable JavaScript to use search.
        </p>
      </div>
    </div>
  </noscript>

  <div id="not-found-error" class="usa-alert usa-alert--error display-none">
    <div class="usa-alert__body">
      <p class="error usa-alert__text">
        Unknown serial number
      </p>
    </div>
  </div>
  <label class="usa-label" for="serial-number">Choose officer</label>
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
    placeholder="Moore, Michel R"
    pattern="\d{5}"
    list="lapd-serial-numbers"
  />

  <datalist id="lapd-serial-numbers">
    {% for cop in site.data['us']['ca']['police']['los_angeles']['roster-2022-08-20'] %}
      <option value="{{ cop['SerialNo'] }}" label="{{ cop['EmployeeName'] }}"/>
    {% endfor %}
  </datalist>

  <input class="usa-button" type="submit" disabled value="See info" />
</form>

<script>
  const form = document.getElementById('lapdSearch')
  const serialNumberField = form.querySelector('input#serial-number')
  const notFoundError = document.getElementById('not-found-error')
  const searchButton = form.querySelector('input[type="submit"]')

  const knownSerialNumbers =
    Array.from(document.getElementById('lapd-serial-numbers').options)
    .map(option => option.value)

  function findLapdCop(event) {
    event.preventDefault()

    const serialNumber = event.target.querySelector('#serial-number').value

    if (knownSerialNumbers.includes(serialNumber)) {
      const path = `/us/ca/police/los_angeles/${serialNumber}`
      window.location.assign(path)
    } else {
      notFoundError.classList.remove('display-none')
    }
  }

  function validateSerialNumber(event) {
    notFoundError.classList.add('display-none')

    if (serialNumberField.validity.valid) {
      searchButton.disabled = false
    } else {
      searchButton.disabled = true
    }
  }

  form.addEventListener('submit', findLapdCop)
  serialNumberField.addEventListener('input', validateSerialNumber)
</script>
