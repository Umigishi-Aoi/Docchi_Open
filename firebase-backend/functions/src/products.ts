export interface ProductData {
    productId: string;
    type: "SUBSCRIPTION" | "NON_SUBSCRIPTION";
  }

export const productDataMap: { [productId: string]: ProductData } = {
  "hide_ads_in_docchi": {
    productId: "hide_ads_in_docchi",
    type: "NON_SUBSCRIPTION",
  },
};
