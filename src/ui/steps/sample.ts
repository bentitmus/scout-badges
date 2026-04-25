import { expect } from "@playwright/test";
import { createBdd } from "playwright-bdd";

const { Given, Then } = createBdd();

Given("I am on home page", async ({ page }) => {
  await page.goto("http://localhost:3000");
});

Then("I see in title {string}", async ({ page }, keyword) => {
  await expect(page).toHaveTitle(new RegExp(keyword));
});
