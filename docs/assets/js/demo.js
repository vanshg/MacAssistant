/*
	Story by HTML5 UP
	html5up.net | @ajlkn
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)

	Note: Only needed for demo purposes. Delete for production sites.
*/

(function($) {

	var $window = $(window);

	// Styles.
		$(
			'<style>' +
				'.demo-animate-all:not(.gallery), .demo-animate-all:not(.gallery) *, .demo-animate-all:not(.gallery) *:before, .demo-animate-all:not(.gallery) *:after { transition: all 0.5s ease-in-out; }' +
				'.demo-controls .property .classes { display: none; }' +
				'.demo-controls .property[data-requires] { display: none; }' +
				'.demo-controls .property[data-requires].active { display: inline; }' +
				'.demo-controls .property .tooltip { position: relative; }' +
				'.demo-controls .property .tooltip:before { content: \'Click to change!\'; font-size: 0.7rem; position: absolute; bottom: 100%; left: 0; background: #47D3E5; color: #ffffff; line-height: 1; white-space: nowrap; font-weight: bold; border-radius: 0.125rem; padding: 0.325rem 0.425rem; animation: demo-controls-tooltip 1.5s forwards; animation-delay: 1s; opacity: 0; }' +
				'.demo-controls .property .tooltip:after { content: \'\'; position: absolute; bottom: calc(100% - 0.25rem); left: 0.5rem; border-left: solid 0.5rem transparent; border-right: solid 0.5rem transparent; border-top: solid 0.5rem #47D3E5; width: 0.5rem; height: 0.5rem; animation: demo-controls-tooltip 1.5s forwards; animation-delay: 1s; opacity: 0; }' +
				'@keyframes demo-controls-tooltip {' +
					'0% { opacity: 0; transform: translateY(0); }' +
					'10% { opacity: 1; transform: translateY(0.125rem); }' +
					'20% { opacity: 1; transform: translateY(-0.125rem); }' +
					'30% { opacity: 1; transform: translateY(0.125rem); }' +
					'40% { opacity: 1; transform: translateY(-0.125rem); }' +
					'50% { opacity: 1; transform: translateY(0.125rem); }' +
					'60% { opacity: 1; transform: translateY(0); }' +
					'90% { opacity: 1; }' +
					'100% { opacity: 0; }' +
				'}' +
			'</style>'
		).appendTo($('head'));

	// Functions.
		$.fn.demo_controls = function(styles, userOptions) {

			var $this = $(this),
				$styleProperty, $stylePropertyClasses,
				$controls, $x, $y, $z,
				options,
				current, i, j, k, s, n, count;

			// No elements?
				if (this.length == 0)
					return $this;

			// Multiple elements?
				if (this.length > 1) {

					for (var i=0; i < this.length; i++)
						$(this[i]).demo_controls(styles, userOptions);

					return $this;

				}

			// Options.
				options = $.extend({
					target: null,
					palette: true
				}, userOptions);

			// Controls.
				if (styles) {

					$controls = $(
						'<span class="demo-controls">' +
							'<span class="property" data-name="style">' +
								'<a href="#" class="title tooltip">style</a>' +
								'<span class="classes"></span>' + (options.palette ? ', ' : ' ') +
							'</span>' +
							(options.palette ?
								'<span class="property active" data-name="scheme">' +
									'<a href="#" class="title">scheme</a>' +
									'<span class="classes">' +
										'<span data-class="-" class="active">default</span>' +
										'<span data-class="invert">invert</span>' +
									'</span>, ' +
								'</span>' +
								'<span class="property active" data-name="color">' +
									'<a href="#" class="title">color</a>' +
									'<span class="classes">' +
										'<span data-class="-" class="active">default</span>' +
										'<span data-class="color1">color1</span>' +
										'<span data-class="color2">color2</span>' +
										'<span data-class="color3">color3</span>' +
										'<span data-class="color4">color4</span>' +
										'<span data-class="color5">color5</span>' +
										'<span data-class="color6">color6</span>' +
										'<span data-class="color7">color7</span>' +
									'</span>, ' +
								'</span>'
							: '') +
						'</span>'
					);

				}
				else {

					$controls = $(
						'<span class="demo-controls">' +
							(options.palette ?
								'<span class="property active" data-name="scheme">' +
									'<a href="#" class="title">scheme</a>' +
									'<span class="classes">' +
										'<span data-class="-" class="active">default</span>' +
										'<span data-class="invert">invert</span>' +
									'</span> and ' +
								'</span>' +
								'<span class="property active" data-name="color">' +
									'<a href="#" class="title">color</a>' +
									'<span class="classes">' +
										'<span data-class="-" class="active">default</span>' +
										'<span data-class="color1">color1</span>' +
										'<span data-class="color2">color2</span>' +
										'<span data-class="color3">color3</span>' +
										'<span data-class="color4">color4</span>' +
										'<span data-class="color5">color5</span>' +
										'<span data-class="color6">color6</span>' +
										'<span data-class="color7">color7</span>' +
									'</span>' +
								'</span>'
							: '') +
						'</span>'
					);

				}

			// Target.
				switch (options.target) {

					case 'previous':
						$this.prev().find('.demo-controls').replaceWith($controls);
						break;

					default:
						$this.find('.demo-controls').replaceWith($controls);
						break;

				}

			// Styles.
				if (styles) {

					$styleProperty = $controls.find('.property[data-name="style"]');
					$stylePropertyClasses = $styleProperty.children('.classes');

					for (i in styles) {

						current = false;
						count = Object.keys(styles[i]).length;
						n = 1;

						// Add to style property.
							$x = $('<span data-class="' + i + '">, ' + i + '</span>')
								.appendTo($stylePropertyClasses);

							if ($this.hasClass(i)) {

								$x.addClass('active');
								current = true;

							}

						// Step through properties.
							for (j in styles[i]) {

								$x = $(
									'<span class="property" data-name="' + j + '" data-requires="' + i + '">' +
										(n == count ? '<span>and </span>' : '') +
										'<a href="#" class="title">' + j + '</a>' +
										'<span class="classes">' +
										'</span>' + (n < count ? ', ' : '') +
									'</span>'
								).appendTo($controls);

								$y = $x.children('.classes');

								if (current)
									$x.addClass('active');

								for (k in styles[i][j]) {

									$z = $('<span data-class="' + k + '">, ' + styles[i][j][k].replace('*', '') + '</span>')
										.appendTo($y);

									if (styles[i][j][k].substr(-1, 1) == '*')
										$z.addClass('default');

									if (current
									&&	$this.hasClass(k))
										$z.addClass('active');

								}

								n++;

							}

					}

				}

			// Events.
				$controls.on('click', 'a', function(event) {
					event.preventDefault();
				});

				$controls.on('click', '.property.active', function(event) {

					var $property = $(this);
					var $classes = $property.find('.classes > *');
					var $current = $classes.filter('.active');
					var $next;

					// Determine next.
						if ($current.length == 0
						||	$current.index() == $classes.length - 1)
							$next = $classes.first();
						else
							$next = $current.next();

					// Turn on animate all.
						$this.addClass('demo-animate-all');

					// Deactivate current.
						$current.removeClass('active');
						$this.removeClass($current.data('class'));

					// Activate next.
						$next.addClass('active');
						$this.addClass($next.data('class'));

					// Turn off animate all.
						setTimeout(function() {
							$this.removeClass('demo-animate-all');
						}, 500);

				});

				$controls.on('click', '.property[data-name="style"]', function(event) {

					var $property = $(this);
					var $classes = $property.find('.classes > *');
					var $current = $classes.filter('.active');
					var $next;

					// Determine next.
						if ($current.length == 0
						||	$current.index() == $classes.length - 1)
							$next = $classes.first();
						else
							$next = $current.next();

					// Turn on animate all.
						$this.addClass('demo-animate-all');

					// Deactivate current.
						$current.removeClass('active');
						$this.removeClass($current.data('class'));

						$controls.find('.property[data-requires="' + $current.data('class') + '"]')
							.removeClass('active');

						$controls.find('.property[data-requires="' + $current.data('class') + '"] > .classes > .active').each(function() {

							$(this).removeClass('active');

							if ($(this).data('class') != '-')
								$this.removeClass($(this).data('class'));

						});

					// Activate next.
						$next.addClass('active');
						$this.addClass($next.data('class'));

						$controls.find('.property[data-requires="' + $next.data('class') + '"]')
							.addClass('active');

						$controls.find('.property[data-requires="' + $next.data('class') + '"] > .classes > .default').each(function() {

							$(this).addClass('active');

							if ($(this).data('class') != '-')
								$this.addClass($(this).data('class'));

						});

					// Turn off animate all.
						setTimeout(function() {
							$this.removeClass('demo-animate-all');
						}, 500);

				});

		};

	// Elements.

		// Wrappers.
			$('.wrapper').demo_controls(null, {
				palette: true
			});

		// Banner.
			$('.banner').demo_controls({
				style1: {
					'size': {
						'-': 'normal',
						'fullscreen': 'fullscreen*'
					},
					'orientation': {
						'orient-left': 'left*',
						'orient-right': 'right'
					},
					'content alignment': {
						'content-align-left': 'left*',
						'content-align-center': 'center',
						'content-align-right': 'right'
					},
					'image position': {
						'image-position-left': 'left',
						'image-position-center': 'center*',
						'image-position-right': 'right'
					}
				},
				style2: {
					'size': {
						'-': 'normal',
						'fullscreen': 'fullscreen*'
					},
					'orientation': {
						'orient-left': 'left',
						'orient-center': 'center*',
						'orient-right': 'right'
					},
					'content alignment': {
						'content-align-left': 'left',
						'content-align-center': 'center*',
						'content-align-right': 'right'
					},
					'image position': {
						'image-position-left': 'left',
						'image-position-center': 'center*',
						'image-position-right': 'right'
					}
				},
				style3: {
					'size': {
						'-': 'normal',
						'fullscreen': 'fullscreen*'
					},
					'orientation': {
						'orient-left': 'left',
						'orient-right': 'right*'
					},
					'content alignment': {
						'content-align-left': 'left*',
						'content-align-center': 'center',
						'content-align-right': 'right'
					},
					'image position': {
						'image-position-left': 'left',
						'image-position-center': 'center*',
						'image-position-right': 'right'
					}
				},
				style4: {
					'size': {
						'-': 'normal',
						'fullscreen': 'fullscreen*'
					},
					'phone type': {
						'iphone': 'iphone*',
						'android': 'android'
					},
					'orientation': {
						'orient-left': 'left',
						'orient-right': 'right*'
					},
					'content alignment': {
						'content-align-left': 'left*',
						'content-align-center': 'center',
						'content-align-right': 'right'
					},
					'image position': {
						'image-position-left': 'left',
						'image-position-center': 'center*',
						'image-position-right': 'right'
					}
				},
				style5: {
					'size': {
						'-': 'normal',
						'fullscreen': 'fullscreen*'
					},
					'content alignment': {
						'content-align-left': 'left',
						'content-align-center': 'center*',
						'content-align-right': 'right'
					},
					'image position': {
						'image-position-left': 'left',
						'image-position-center': 'center*',
						'image-position-right': 'right'
					}
				}
			});

		// Spotlight.
			$('.spotlight').demo_controls({
				style1: {
					'orientation': {
						'orient-left': 'left',
						'orient-right': 'right*'
					},
					'content alignment': {
						'content-align-left': 'left*',
						'content-align-center': 'center',
						'content-align-right': 'right'
					},
					'image position': {
						'image-position-left': 'left*',
						'image-position-center': 'center',
						'image-position-right': 'right'
					}
				},
				style2: {
					'orientation': {
						'orient-left': 'left',
						'orient-right': 'right*'
					},
					'content alignment': {
						'content-align-left': 'left*',
						'content-align-center': 'center',
						'content-align-right': 'right'
					},
					'image position': {
						'image-position-left': 'left',
						'image-position-center': 'center*',
						'image-position-right': 'right'
					}
				},
				style3: {
					'phone type': {
						'iphone': 'iphone*',
						'android': 'android'
					},
					'orientation': {
						'orient-left': 'left',
						'orient-right': 'right*'
					},
					'content alignment': {
						'content-align-left': 'left*',
						'content-align-center': 'center',
						'content-align-right': 'right'
					},
					'image position': {
						'image-position-left': 'left',
						'image-position-center': 'center*',
						'image-position-right': 'right'
					}
				},
				style4: {
					'size': {
						'-size': 'normal',
						'fullscreen': 'fullscreen*',
						'halfscreen': 'halfscreen'
					},
					'orientation': {
						'orient-left': 'left*',
						'orient-center': 'center',
						'orient-right': 'right'
					},
					'content alignment': {
						'content-align-left': 'left*',
						'content-align-center': 'center',
						'content-align-right': 'right'
					},
					'image position': {
						'image-position-left': 'left',
						'image-position-center': 'center*',
						'image-position-right': 'right'
					}
				},
				style5: {
					'size': {
						'-size': 'normal',
						'fullscreen': 'fullscreen*',
						'halfscreen': 'halfscreen'
					},
					'orientation': {
						'orient-left': 'left*',
						'orient-center': 'center',
						'orient-right': 'right'
					},
					'content alignment': {
						'content-align-left': 'left*',
						'content-align-center': 'center',
						'content-align-right': 'right'
					},
					'image position': {
						'image-position-left': 'left',
						'image-position-center': 'center*',
						'image-position-right': 'right'
					}
				},
			});

		// Gallery.
			$('.gallery').demo_controls({
				style1: {
					'size': {
						'small': 'small',
						'medium': 'medium*',
						'big': 'big'
					}
				},
				style2: {
					'size': {
						'small': 'small',
						'medium': 'medium*',
						'big': 'big'
					}
				},
			}, {
				target: 'previous',
				palette: false
			});

		// Items.
			$('.items').demo_controls({
				style1: {
					'size': {
						'small': 'small',
						'medium': 'medium*',
						'big': 'big'
					}
				},
				style2: {
					'size': {
						'small': 'small',
						'medium': 'medium*',
						'big': 'big'
					}
				},
				style3: {
					'size': {
						'small': 'small',
						'medium': 'medium*',
						'big': 'big'
					}
				}
			}, {
				target: 'previous',
				palette: false
			});

})(jQuery);