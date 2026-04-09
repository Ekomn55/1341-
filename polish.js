(function () {
    'use strict';

    /* ── Floating call-to-order button ── */
    document.body.insertAdjacentHTML('beforeend',
        '<a href="tel:6124540549" class="float-call" aria-label="Call to order">' +
            '<svg class="float-call-icon" width="16" height="16" viewBox="0 0 24 24" fill="currentColor">' +
            '<path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 ' +
            '1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 ' +
            '0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/>' +
            '</svg>' +
            'Call to Order' +
        '</a>' +
        '<button class="back-to-top" id="back-to-top" aria-label="Back to top">&#8679;</button>'
    );

    /* ── Back to top ── */
    var btt = document.getElementById('back-to-top');
    btt.addEventListener('click', function () {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
    window.addEventListener('scroll', function () {
        btt.classList.toggle('visible', window.scrollY > 480);
    }, { passive: true });

    /* ── Scroll-reveal via IntersectionObserver ── */
    if ('IntersectionObserver' in window) {
        var io = new IntersectionObserver(function (entries) {
            entries.forEach(function (e) {
                if (e.isIntersecting) {
                    e.target.classList.add('in');
                    io.unobserve(e.target);
                }
            });
        }, { threshold: 0.07, rootMargin: '0px 0px -28px 0px' });

        var revealSel = [
            '.section',
            '.p-section',
            '.t-section',
            '.bundle-card',
            '.p-delivery',
            '.p-cta',
            '.coll-card',
            '.review-card',
            '.faq-item',
            '.gallery-item',
            '.g-card',
            '.about-section',
            '.founder-section',
            '.cta-band',
            '.newsletter-section'
        ].join(',');

        document.querySelectorAll(revealSel).forEach(function (el) {
            // Don't hide elements already in the header area
            if (!el.closest('.t-header') && !el.closest('nav') && !el.closest('footer')) {
                el.classList.add('reveal');
                io.observe(el);
            }
        });
    }

    /* ── Mobile nav: close when a link is tapped ── */
    var mobileNav = document.getElementById('mobile-nav');
    if (mobileNav) {
        mobileNav.querySelectorAll('a').forEach(function (link) {
            link.addEventListener('click', function () {
                mobileNav.classList.remove('open');
            });
        });
    }
})();
