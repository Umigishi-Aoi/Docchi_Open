import {ProductData} from "./products";

/**
* PurchaseHandlerの定義
*/
export abstract class PurchaseHandler {
  /**
  * 購入確認処理
  * @param {string} userId is userId
  * @param {ProductData} productData is productData
  * @param {string} token is purchase token
  */
  async verifyPurchase(
      userId: string,
      productData: ProductData,
      token: string,
  ): Promise<boolean> {
    switch (productData.type) {
      case "SUBSCRIPTION":
        return this.handleSubscription(userId, productData, token);
      case "NON_SUBSCRIPTION":
        return this.handleNonSubscription(userId, productData, token);
      default:
        return false;
    }
  }

  abstract handleNonSubscription(
      userId: string,
      productData: ProductData,
      token: string,
  ): Promise<boolean>;

  abstract handleSubscription(
      userId: string,
      productData: ProductData,
      token: string,
  ): Promise<boolean>;
}
