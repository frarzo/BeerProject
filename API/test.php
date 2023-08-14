<html>

<body>

    <form method="post" action="api.php">
        nome: <input type="text" name="nome">
        psw: <input type="text" name="psw">
        <input type="submit">
    </form>

    <?php
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        // collect value of input field
        $nome = $_POST['nome'];
        $psw = $_POST['psw'];
        if (empty($nome)) {
            echo "Name is empty";
        } else {
            echo $nome;
            echo $psw;
        }
    }
    ?>

</body>

</html>