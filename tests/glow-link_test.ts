import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure user can create profile with valid skin type",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "glow-link",
        "create-profile",
        ["oily", types.uint(5)],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    assertEquals(block.receipts[0].result.expectOk(), true);
  },
});

Clarinet.test({
  name: "Ensure invalid skin types are rejected",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "glow-link",
        "create-profile",
        ["invalid-type", types.uint(5)],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts[0].result.expectErr(), 'u103');
  },
});

Clarinet.test({
  name: "Ensure duplicate profiles are rejected",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block1 = chain.mineBlock([
      Tx.contractCall(
        "glow-link",
        "create-profile",
        ["oily", types.uint(5)],
        wallet_1.address
      )
    ]);
    
    let block2 = chain.mineBlock([
      Tx.contractCall(
        "glow-link",
        "create-profile",
        ["dry", types.uint(3)],
        wallet_1.address
      )
    ]);
    
    assertEquals(block2.receipts[0].result.expectErr(), 'u101');
  },
});
