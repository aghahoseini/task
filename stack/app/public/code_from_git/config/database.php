<?php 
    class Database {
        private $host ;
        private $database_name ;
        private $username ;
        private $password ;

        public $conn;

        public function __construct()
        {
            //$this->host = $_ENV['mysql_host'].":3306";
            
            $this->host = $_ENV['mysql_host'].":".$_ENV['mysql_port'];
            $this->username = $_ENV['mysql_user'];
            $this->database_name= $_ENV['mysql_db'];
            $this->password= $_ENV['mysql_user_pass'];
        }

        public function getConnection(){
            $this->conn = null;
            //$this->username = 'root';
            try{
                $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->database_name, $this->username, $this->password);
                $this->conn->exec("set names utf8");
            }catch(PDOException $exception){
                echo "Database could not be connected: " . $exception->getMessage();
            }
            return $this->conn;
        }
    }  
?>
