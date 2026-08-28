<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav class="navbar">
    <div class="container nav-inner">

        <!-- Logo — fixed left -->
        <a href="${pageContext.request.contextPath}/home" class="nav-brand">
            <img src="${pageContext.request.contextPath}/images/sunrise-logo.png" alt="Sunrise Dental">
            <div class="nav-brand-text">
                <strong>Sunrise Dental</strong>
                <span>Clinic &amp; Implant Centre</span>
            </div>
        </a>

        <!-- Links — centred -->
        <ul class="nav-links" id="navLinks">
            <li><a href="${pageContext.request.contextPath}/home"      id="nav-home">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/about"     id="nav-about">About Us</a></li>
            <li><a href="${pageContext.request.contextPath}/home#services"  id="nav-services">Services</a></li>
            <li><a href="${pageContext.request.contextPath}/home#doctors"   id="nav-doctors">Our Doctors</a></li>
            <li><a href="${pageContext.request.contextPath}/contact"   id="nav-contact">Contact</a></li>
        </ul>

        <!-- Mobile hamburger -->
        <button class="nav-hamburger" onclick="toggleMobileNav()" aria-label="Toggle menu">
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none"
                 stroke="#1a5276" stroke-width="2.2" stroke-linecap="round">
                <line x1="3" y1="6"  x2="21" y2="6"/>
                <line x1="3" y1="12" x2="21" y2="12"/>
                <line x1="3" y1="18" x2="21" y2="18"/>
            </svg>
        </button>
    </div>
</nav>

<script>
(function () {
    // Determine which page we're on
    var path = window.location.pathname;
    var hash = window.location.hash;

    function clearActive() {
        document.querySelectorAll('.nav-links a').forEach(function(a) {
            a.classList.remove('active');
        });
    }

    function setActive(id) {
        clearActive();
        var el = document.getElementById(id);
        if (el) el.classList.add('active');
    }

    // Set initial active based on path + hash
    function initActive() {
        if (path.indexOf('/about') !== -1) {
            setActive('nav-about');
        } else if (path.indexOf('/contact') !== -1) {
            setActive('nav-contact');
        } else if (path.indexOf('/home') !== -1 || path.endsWith('/')) {
            if (hash === '#services') {
                setActive('nav-services');
            } else if (hash === '#doctors') {
                setActive('nav-doctors');
            } else {
                setActive('nav-home');
            }
        }
    }

    initActive();

    // On the home page, use IntersectionObserver to highlight correct link on scroll
    if (path.indexOf('/home') !== -1 || path.endsWith('/')) {
        window.addEventListener('DOMContentLoaded', function () {
            var sections = [
                { id: 'services', navId: 'nav-services' },
                { id: 'doctors',  navId: 'nav-doctors'  }
            ];

            var observer = new IntersectionObserver(function(entries) {
                entries.forEach(function(entry) {
                    if (entry.isIntersecting) {
                        var match = sections.find(function(s) { return s.id === entry.target.id; });
                        if (match) setActive(match.navId);
                    }
                });
            }, { threshold: 0.3 });

            // When scrolled back near top, re-activate Home
            var heroSection = document.querySelector('.hero');
            if (heroSection) {
                var heroObserver = new IntersectionObserver(function(entries) {
                    if (entries[0].isIntersecting) setActive('nav-home');
                }, { threshold: 0.1 });
                heroObserver.observe(heroSection);
            }

            sections.forEach(function(s) {
                var el = document.getElementById(s.id);
                if (el) observer.observe(el);
            });
        });
    }

    // Mobile nav toggle
    window.toggleMobileNav = function() {
        document.getElementById('navLinks').classList.toggle('mobile-open');
    };

    // Scroll shadow
    window.addEventListener('scroll', function () {
        document.querySelector('.navbar').classList.toggle('scrolled', window.scrollY > 20);
    });
})();
</script>
