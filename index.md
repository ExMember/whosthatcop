---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

# LAPD

Look up LAPD officers by serial number.

<form id='lapdSearch' class="usa-form">
  <label class="usa-label" for="serial-number">Serial number (5 digits)</label>
  <input
    class="usa-input"
    id="serial-number"
    name="serial-number"
    type="text"
    autocomplete="off"
    autocapitalize="off"
    autocorrect="off"
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

  <noscript>
    <div class="usa-alert usa-alert--error usa-alert--slim">
      <div class="usa-alert__body">
        <p class="usa-alert__text">
          Enable JavaScript to use search.
        </p>
      </div>
    </div>
  </noscript>

  <input class="usa-button" type="submit" value="Find Officer" />
</form>

<script>
function findLapdCop(event) {
  event.preventDefault()
  const serialNumber = event.target.querySelector('#serial-number').value
  const path = `/us/ca/police/los_angeles/${serialNumber}`
  window.location.assign(path)
}

const form = document.getElementById('lapdSearch')
form.addEventListener('submit', findLapdCop)
</script>
