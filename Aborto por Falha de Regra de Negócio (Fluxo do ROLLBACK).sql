-- Executar o teste que força o ROLLBACK (tentar levar 15 unidades)
EXEC sp_RegistarVenda @ClienteID = 1, @FuncionarioID = 1, @ProdutoID = 1, @QuantidadeVendida = 15;

-- Verificar que o stock não se alterou e continua seguro
SELECT NomeProduto, QuantidadeStock FROM Produtos WHERE ProdutoID = 1;