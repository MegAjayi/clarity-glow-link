import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure only owner can add products",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const owner = accounts.get("deployer")!;
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "products",
        "add-product",
        [
          types.principal(wallet_1.address),
          types.ascii("Test Product"),
          types.ascii("Cleanser"),
          types.list(["oily", "dry"]),
          types.list(["sunny", "rainy"])
        ],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts[0].result.expectErr(), 'u100');
  },
});

Clarinet.test({
  name: "Ensure product details are stored correctly",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const product_id = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "products",
        "add-product",
        [
          types.principal(product_id.address),
          types.ascii("Test Product"),
          types.ascii("Cleanser"),
          types.list(["oily", "dry"]),
          types.list(["sunny", "rainy"])
        ],
        deployer.address
      )
    ]);
    
    assertEquals(block.receipts[0].result.expectOk(), true);
    
    let response = chain.callReadOnlyFn(
      "products",
      "get-product",
      [types.principal(product_id.address)],
      deployer.address
    );
    
    assertEquals(response.result.expectOk().expectSome().name, "Test Product");
  },
});
