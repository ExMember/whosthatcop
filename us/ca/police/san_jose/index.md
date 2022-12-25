---
layout: home
---

# San Jose Police Department (SJPD)

<form id='search' novalidate class="usa-form">
  <legend class="usa-legend">
    Get information about SJPD officers.
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
        Unknown badge number
      </p>
    </div>
  </div>
  <label class="usa-label" for="serial-number">Choose officer</label>
  <input
    class="usa-input"
    id="badge-number"
    name="badge-number"
    type="text"
    autocomplete="off"
    autocapitalize="off"
    autocorrect="off"
    autofocus="true"
    required="required"
    size=6
    placeholder="3324"
    pattern="\d{4}T?"
    list="sjpd-badge-numbers"
  />

  <datalist id="sjpd-badge-numbers">
    {% for cop in site.data['us']['ca']['police']['san_jose']['roster-2022-09-26'] %}
      <option value="{{ cop['BadgeNumber'] }}" label="{{ cop['LastName'] }}, {{ cop['FirstName'] }}"/>
    {% endfor %}
  </datalist>

  <input class="usa-button" type="submit" disabled value="See info" />
</form>

<script>
  const form = document.getElementById('search')
  const badgeNumberField = form.querySelector('input#badge-number')
  const notFoundError = document.getElementById('not-found-error')
  const searchButton = form.querySelector('input[type="submit"]')

  const knownBadgeNumbers =
    Array.from(document.getElementById('sjpd-badge-numbers').options)
    .map(option => option.value)

  function findCop(event) {
    event.preventDefault()

    const badgeNumber = event.target.querySelector('#badge-number').value

    if (knownBadgeNumbers.includes(badgeNumber)) {
      const path = `/us/ca/police/san_jose/${badgeNumber}`
      window.location.assign(path)
    } else {
      notFoundError.classList.remove('display-none')
    }
  }

  function validateBadgeNumber(event) {
    notFoundError.classList.add('display-none')

    if (badgeNumberField.validity.valid) {
      searchButton.disabled = false
    } else {
      searchButton.disabled = true
    }
  }

  form.addEventListener('submit', findCop)
  badgeNumberField.addEventListener('input', validateBadgeNumber)
</script>
