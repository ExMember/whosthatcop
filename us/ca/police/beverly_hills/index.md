---
layout: home
---

# Beverly Hill Police Department (BHPD)

<form id='search' novalidate class="usa-form">
  <legend class="usa-legend">
    Get information about BHPD officers.
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
        Unknown officer
      </p>
    </div>
  </div>
  <label class="usa-label" for="serial-number">Choose officer</label>
  <input
    class="usa-input"
    id="filename"
    name="officer"
    type="text"
    autocomplete="off"
    autocapitalize="off"
    autocorrect="off"
    autofocus="true"
    required="required"
    size=20
    placeholder="5409-stainbrook-mark"
    list="bhpd-files"
  />

  <datalist id="bhpd-files">
    {% for cop in site.data['us']['ca']['police']['beverly_hills']['roster-2022'] %}
      <option value="{{ cop['SerialNumber'] }}-{{ cop['LastName']| downcase }}-{{ cop['GivenName1'] | downcase }}" label="{{ cop['LastName'] }}, {{ cop['GivenName1'] }}"/>
    {% endfor %}
  </datalist>

  <input class="usa-button" type="submit" disabled value="See info" />
</form>

<script>
  const form = document.getElementById('search')
  const filenameField = form.querySelector('input#filename')
  const notFoundError = document.getElementById('not-found-error')
  const searchButton = form.querySelector('input[type="submit"]')

  const knownFilenames =
    Array.from(document.getElementById('bhpd-files').options)
    .map(option => option.value)

  function findCop(event) {
    event.preventDefault()

    const filename = event.target.querySelector('#filename').value

    if (knownFilenames.includes(filename)) {
      const path = `/us/ca/police/beverly_hills/${filename}`
      window.location.assign(path)
    } else {
      notFoundError.classList.remove('display-none')
    }
  }

  function validateFilename(event) {
    notFoundError.classList.add('display-none')

    if (filenameField.validity.valid) {
      searchButton.disabled = false
    } else {
      searchButton.disabled = true
    }
  }

  form.addEventListener('submit', findCop)
  filenameField.addEventListener('input', validateFilename)
</script>
