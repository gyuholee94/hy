<h2>마당서점, 도서목록</h2>
<?php
    $conn = mysqli_connect('localhost','madang','madang1234!!Q','madang');
    if (mysqli_connect_error($conn)){
        echo '접속에 실패하였습니다.';
        exit();
        
    } else {
        echo '접속에 성공하였습니다.';
    }
?>