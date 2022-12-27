---
layout: home
---

# La Verne Police Department (LVPD)

<form id='search' novalidate class="usa-form">
  <legend class="usa-legend">
    Get information about LVPD officers.
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
        Unknown employee ID
      </p>
    </div>
  </div>
  <label class="usa-label" for="id-number">Choose officer</label>
  <input
    class="usa-input"
    id="id-number"
    name="id-number"
    type="text"
    autocomplete="off"
    autocapitalize="off"
    autocorrect="off"
    autofocus="true"
    required="required"
    size=6
    placeholder="1187"
    pattern="\d{3,4}"
    list="lvpd-id-numbers"
  />

  <datalist id="lvpd-id-numbers">
    {% for cop in site.data['us']['ca']['police']['la_verne']['La_Verne_sworn_roster_2022-09-26'] %}
      <option value="{{ cop['EmployeeId'] }}" label="{{ cop['LastName'] }}, {{ cop['GivenName1'] }}"/>
    {% endfor %}
  </datalist>

  <input class="usa-button" type="submit" disabled value="See info" />
</form>

<script>
  const form = document.getElementById('search')
  const idNumberField = form.querySelector('input#id-number')
  const notFoundError = document.getElementById('not-found-error')
  const searchButton = form.querySelector('input[type="submit"]')

  const knownIdNumbers =
    Array.from(document.getElementById('lvpd-id-numbers').options)
    .map(option => option.value)

  function findCop(event) {
    event.preventDefault()

    const idNumber = event.target.querySelector('#id-number').value

    if (knownIdNumbers.includes(idNumber)) {
      const path = `/us/ca/police/la_verne/${idNumber}`
      window.location.assign(path)
    } else {
      notFoundError.classList.remove('display-none')
    }
  }

  function validateIdNumber(event) {
    notFoundError.classList.add('display-none')

    if (idNumberField.validity.valid) {
      searchButton.disabled = false
    } else {
      searchButton.disabled = true
    }
  }

  form.addEventListener('submit', findCop)
  idNumberField.addEventListener('input', validateIdNumber)
</script>
