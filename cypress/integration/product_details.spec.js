describe('home page', () => {

  it('can visit the homepage', () => {
    cy.visit('/')
  })

  it("There is products on the page", () => {
    cy.get(".products article").should("be.visible");
  });

  it("There is 2 products on the page", () => {
    cy.get(".products article").should("have.length", 2);
  });
  
  it('let you visti the selected product detail page', () => {
    cy.visit('/')
    cy.get(".products article").first().click()
    cy.url().should("include", "/products/2")
  })

})
