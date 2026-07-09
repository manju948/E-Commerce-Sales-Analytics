// ================= YEAR =================
const year = document.getElementById("year");
if (year) {
    year.textContent = new Date().getFullYear();
}

// ================= LOADER =================
window.onload = function () {
    const loader = document.getElementById("loader");
    if (loader) {
        loader.style.display = "none";
    }
};

// ================= AOS =================
if (typeof AOS !== "undefined") {
    AOS.init({
        duration: 1000,
        once: true
    });
}

// ================= BACK TO TOP =================
const backToTop = document.getElementById("backToTop");

window.addEventListener("scroll", () => {

    const scrollTop = document.documentElement.scrollTop;
    const scrollHeight =
        document.documentElement.scrollHeight -
        document.documentElement.clientHeight;

    const progress =
        (scrollTop / scrollHeight) * 100;

    const progressBar = document.getElementById("progressBar");

    if (progressBar) {
        progressBar.style.width = progress + "%";
    }

    if (backToTop) {
        if (scrollTop > 300) {
            backToTop.classList.add("show");
        } else {
            backToTop.classList.remove("show");
        }
    }
});

if (backToTop) {
    backToTop.addEventListener("click", () => {
        window.scrollTo({
            top: 0,
            behavior: "smooth"
        });
    });
}

// ================= COUNTERS =================
const counters = document.querySelectorAll(".counter");

function animateCounter(counter) {

    const target = Number(counter.dataset.target);

    const prefix = counter.dataset.prefix || "";
    const suffix = counter.dataset.suffix || "";

    let current = 0;

    const speed = target / 100;

    function update() {

        if (current < target) {

            current += speed;

            counter.innerText =
                prefix +
                Math.floor(current).toLocaleString("en-IN") +
                suffix;

            requestAnimationFrame(update);

        } else {

            counter.innerText =
                prefix +
                target.toLocaleString("en-IN") +
                suffix;
        }

    }

    update();
}

const observer = new IntersectionObserver((entries, obs) => {

    entries.forEach(entry => {

        if (entry.isIntersecting) {

            animateCounter(entry.target);

            obs.unobserve(entry.target);

        }

    });

}, {
    threshold: 0.5
});

counters.forEach(counter => observer.observe(counter));

// ================= CHART =================
const salesChart = document.getElementById("salesChart");

if (salesChart && typeof Chart !== "undefined") {

    new Chart(salesChart, {

        type: "line",

        data: {

            labels: ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],

            datasets: [{

                label: "Revenue",

                data: [120000,150000,170000,160000,190000,210000,230000,220000,250000,260000,280000,300000],

                borderColor: "#6c5ce7",

                backgroundColor: "rgba(108,92,231,.2)",

                fill: true,

                tension: .4

            }]

        }

    });

}

const categoryChart = document.getElementById("categoryChart");

if (categoryChart && typeof Chart !== "undefined") {

    new Chart(categoryChart, {

        type: "doughnut",

        data: {

            labels: [
                "Electronics",
                "Clothing",
                "Home",
                "Books",
                "Sports"
            ],

            datasets: [{

                data: [35,25,20,10,10],

                backgroundColor: [
                    "#6c5ce7",
                    "#00cec9",
                    "#fdcb6e",
                    "#e17055",
                    "#0984e3"
                ]

            }]

        }

    });

}