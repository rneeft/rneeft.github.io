---
title: Decorators DotNet Dependency Injector
date: 2024-05-31 11:00:00 +0200
categories: [Programming, Patterns]
tags: [decorator,di,dependency-injector]     # TAG names should always be lowercase
---

---
title: Site starter snippets
date: 2024-05-31 11:00:00 +0200
categories: [Programming, html]
tags: [start,programming,html,bootstrap,cytoscape]     # TAG names should always be lowercase
---

Sometimes, I just want to start quickly with an empty HTML file. Here are some starting snippets for HTML.

## Bootstrap

Quick and easy starter setup for bootstrap

### index.html

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap started</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  </head>
  <body>
    <div class="container">
        <h1>Bootstrap started</h1>
    <div class="mb-3">
        <label for="exampleFormControlInput1" class="form-label">Email address</label>
        <input type="email" class="form-control" id="exampleFormControlInput1" placeholder="name@example.com">
      </div>
      <div class="mb-3">
        <label for="exampleFormControlTextarea1" class="form-label">Example textarea</label>
        <textarea class="form-control" id="exampleFormControlTextarea1" rows="3"></textarea>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  </body>
</html>
```

## Cytoscape.js

For Cytoscape, I always use two files: the HTML page and a data.json file containing the graph data. When using vscode, you need to run the data in a live server like [Live Server from Ritwick Dev](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer)

### index.html

```html
<!doctype html>
<html lang="en">
    <head>
        <title>Cytoscape.js started</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.7.0.min.js" integrity="sha256-2Pmvv0kuTBOenSvLm6bvfBSSHrUJ+3A7x6P5Ebd07/g=" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.25.0/cytoscape.min.js" integrity="sha512-QWYhhlZXfhMzyiML+xSFHYINwLvLsVd2Ex6QKA4JQzulKAsXiHoNXN1gCgB7GUaVL8xGI9L6XXyqPJVLASVP7g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://unpkg.com/dagre@0.7.4/dist/dagre.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

        <style>
            #cy {
                position: absolute;
                width: 100%;
                height: 100%;
 }
        </style>
    </head>
    <body>
        <div id="cy" ></div>

        <script>
            $.ajaxSetup({
                scriptCharset: "utf-8",
                contentType: "application/json; charset=utf-8"
 });

            $.getJSON("http://127.0.0.1:5500/data.json", function (data) {
                cy = cytoscape({
                    container: document.getElementById('cy'),
                    elements: data,
                    style: [
 {
                            selector: 'node',
                            style: {
                                label: 'data(name)',
                                'width': '60px',
                                'height': '60px',
 }
 },
 {
                            selector: 'edge',
                            style: {
                                label: 'data(name)',
                                'width': 5,
                                'curve-style': 'bezier',
 }
 }
 ]
 });
 });

        
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
    </body>
</html>
```

### data.json

```json
{
    "nodes": [
 {
            "data": { "id": "0", "name": "Hello" }
 },
 {
            "data": { "id": "1", "name": "World" }
 }
 ],
    "edges": [
 {
            "data": { "source" : "0", "target" : "1", "name" : "," }
 }
 ]
}
```
