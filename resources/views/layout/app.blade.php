<html>
    <head>
        <meta charset= "utfs-8">
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100&display=swap" rel="stylesheet">
        
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital@1&family=Roboto:wght@100;400&display=swap" rel="stylesheet">
        @section('contenuti aggiuntivi')
        @show
        
        <title>Azienda Ospedaliera</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
    </head>
    <body>
        <main>
            <header>
                <nav>
                    <a href="./Home">Home </a>
                    
                    @if(Session::get('username')==null)
                        <a href="./login">Log In</a>   
                    @else
                        <a href="./logout">Log Out</a>
                    @endif
                    <div id="hiddenMenu">
                        <div></div>
                        <div></div>
                        <div></div>
                    </div>
                
                </nav>
                
                

                <div id="overlay"></div>
                @section('sottotitolo')
                @show
                <h1>Azienda Ospedaliera</h1>
               
            </header>
            @section('all')
            @show
            <footer>
                <div id='name'>Daniel Di Nora O46002100</div>
                <em>Progetto Web Programming</em>
                
            </footer>
        </main>
    </body>
</html>