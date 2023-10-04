import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const stripe = Stripe(this.element.getAttribute("data-stripe-publishable-key"))
    let elements
    initialize(this.element.getAttribute("data-stripe-client-secret"))
    this.element.addEventListener("submit", handleSubmit)
    
    const base_url = this.element.getAttribute("data-base-url")
    const tokujo_id = this.element.getAttribute("data-tokujo-id")
    const order_id = this.element.getAttribute("data-order-id")
    const checkout_session_id = this.element.getAttribute("data-checkout-session-id")

    async function initialize(client_secret) {
      elements = stripe.elements({ clientSecret: client_secret })
      const paymentElement = elements.create("payment")
      paymentElement.mount("#payment-element")
    }

    async function handleSubmit(e) {
      e.preventDefault()

      const { error } = await stripe.confirmSetup({
        elements, confirmParams: {
          return_url: `http://${base_url}/tokujo_sale_orders/${order_id}/succeeded?checkout_session_id=${checkout_session_id}&tokujo_id=${tokujo_id}`
        }
      })

      if (error) {
        // This point will only be reached if there is an immediate error when
        // confirming the payment. Show error to your customer (for example, payment
        // details incomplete)
        const messageContainer = document.querySelector("#error-message");
        messageContainer.textContent = error.message;
      } else {
        // Your customer will be redirected to your `return_url`. For some payment
        // methods like iDEAL, your customer will be redirected to an intermediate
        // site first to authorize the payment, then redirected to the `return_url`.
      }
    }

    function setLoading(isLoading) {
      if (isLoading) {
        document.querySelector("#submit").disabled = true;
        document.querySelector("#spinner").classList.remove("hidden");
        document.querySelector("#button-text").classList.add("hidden");
      } else {
        document.querySelector("#submit").disabled = false;
        document.querySelector("#spinner").classList.add("hidden");
        document.querySelector("#button-text").classList.remove("hidden");
      }
    }
  }
}


// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   connect() {
//     const stripe = Stripe(this.element.getAttribute("data-stripe-publishable-key"))
//     let elements
//     initialize(this.element.getAttribute("data-stripe-client-secret"))
//     this.element.addEventListener("submit", handleSubmit)
    
//     const base_url = this.element.getAttribute("data-base-url")
//     const tokujo_id = this.element.getAttribute("data-tokujo-id")
//     const order_id = this.element.getAttribute("data-order-id")

//     async function initialize(client_secret) {
//       elements = stripe.elements({ clientSecret: client_secret })
//       const paymentElement = elements.create("payment")
//       paymentElement.mount("#payment-element")
//     }

//     async function handleSubmit(e) {
//       e.preventDefault()

//       const { error } = await stripe.confirmSetup({
//         elements, confirmParams: {
//           return_url: `http://${base_url}/tokujo_sales/${tokujo_id}/orders/${order_id}/succeeded`
//         }
//       })

//       if (error) {
//         // This point will only be reached if there is an immediate error when
//         // confirming the payment. Show error to your customer (for example, payment
//         // details incomplete)
//         const messageContainer = document.querySelector("#error-message");
//         messageContainer.textContent = error.message;
//       } else {
//         // Your customer will be redirected to your `return_url`. For some payment
//         // methods like iDEAL, your customer will be redirected to an intermediate
//         // site first to authorize the payment, then redirected to the `return_url`.
//       }
//     }

//     function setLoading(isLoading) {
//       if (isLoading) {
//         document.querySelector("#submit").disabled = true;
//         document.querySelector("#spinner").classList.remove("hidden");
//         document.querySelector("#button-text").classList.add("hidden");
//       } else {
//         document.querySelector("#submit").disabled = false;
//         document.querySelector("#spinner").classList.add("hidden");
//         document.querySelector("#button-text").classList.remove("hidden");
//       }
//     }
//   }
// }