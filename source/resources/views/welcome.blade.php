<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Laravel</title>
        <!-- CSRF Token -->
        <meta name="csrf-token" content="{{ csrf_token() }}">
        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css?family=Nunito:200,600" rel="stylesheet">

        <link href="/css/app.css" rel="stylesheet" type="text/css"/>

        <script src="{{ asset('js/app.js') }}" defer></script>

    </head>
    <body>
        <div id='app'>
            <wheel-lucky></wheel-lucky>
        </div>
    </body>
</html>
