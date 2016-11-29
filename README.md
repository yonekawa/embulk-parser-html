# HTML parser plugin for Embulk

WIP

## Overview

* **Plugin type**: parser
* **Guess supported**: no

## Configuration

- **schema**:  (array, required)

## Example

```yaml
in:
  type: any file input plugin type
  parser:
    type: html
    schema:
      - {name: name, xpath: '//table[@class="table1"]/tr/td[1]', type: string}
      - {name: amount, xpath: '//table[@class="table1"]/tr/td[2]', type: long}
      - {name: description, xpath: '//table[@class="table1"]/tr/td[3]', type: string}

```
