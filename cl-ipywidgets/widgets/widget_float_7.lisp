(in-package :cl-ipywidgets)

;;https://github.com/drmeister/widget-dev/blob/master/ipywidgets6/widgets/widget_float.py#L19
(defclass %float (description-widget value-widget core-widget)
  ((value :initarg :value :accessor value
	   :type float
	   :initform 0.0
	   :metadata (:sync t
			    :json-name "value"
			    :help "Float value"))
   )
  (:metaclass traitlets:traitlet-class))


;;https://github.com/drmeister/widget-dev/blob/master/ipywidgets6/widgets/widget_float.py#L32
(defclass %bounded-float (%float)
  ((value :validator validate-float)
   (max :initarg :max :accessor max
	 :type float
	 :initform 100.0
	 :validator validate-float-max
	 :metadata (:sync t
			  :json-name "max"
			  :help "Max value"))
   (min :initarg :min :accessor min
	 :type float
	 :initform 0.0
	 :validator validate-float-min
	 :metadata (:sync t
			  :json-name "min"
			  :help "Min value"))
   )
  (:metaclass traitlets:traitlet-class))

(defun validate-float (object val)
  (if (and (slot-boundp object 'min) (slot-boundp object 'max))
      (let ((min (min object)) (max (max object)))
	(cond ((< val min) min)
	      ((> val max) max)
	      (t val)))
      val))

#|| TODO
class _BoundedLogFloat(_Float):
    max = CFloat(4.0, help="Max value for the exponent").tag(sync=True)
    min = CFloat(0.0, help="Min value for the exponent").tag(sync=True)
    base = CFloat(10.0, help="Base of value").tag(sync=True)
    value = CFloat(1.0, help="Float value").tag(sync=True)

    @validate('value')
    def _validate_value(self, proposal):
        """Cap and floor value"""
        value = proposal['value']
        if self.base ** self.min > value or self.base ** self.max < value:
            value = min(max(value, self.base **  self.min), self.base **  self.max)
        return value

    @validate('min')
    def _validate_min(self, proposal):
        """Enforce base ** min <= value <= base ** max"""
        min = proposal['value']
        if min > self.max:
            raise TraitError('Setting min > max')
        if self.base ** min > self.value:
            self.value = self.base ** min
        return min

    @validate('max')
    def _validate_max(self, proposal):
        """Enforce base ** min <= value <= base ** max"""
        max = proposal['value']
        if max < self.min:
            raise TraitError('setting max < min')
        if self.base ** max < self.value:
            self.value = self.base ** max
        return max



||#

;;https://github.com/drmeister/widget-dev/blob/master/ipywidgets6/widgets/widget_float.py#L67
(defclass-widget-register float-text (%float)
  ((disabled :initarg :disabled :accessor disabled
	     :type bool
	     :initform :false
	     :metadata (:sync t
			      :json-name "disabled"
			      :help "Enable or disable user changes"))
   (continuous-update :initarg :continuous-update :accessor continuous-update
		      :type bool
		      :initform :false
		      :metadata (:sync t
				       :json-name "continuous_update"
				       :help "Update the value as the user types. IF False, update on submission, e.g., pressing Enter or navigating away."))
    (step :initarg :step :accessor step
	  :type float
	  :initform 0.1
	  :metadata (:sync t
			   :json-name "step"
			   :help "Minimum step to increment the value"))
   )
  (:default-initargs
   :view-name (unicode "FloatTextView")
    :model-name (unicode "FloatTextModel")
    )
  (:metaclass traitlets:traitlet-class))


;;https://github.com/drmeister/widget-dev/blob/master/ipywidgets6/widgets/widget_float.py#L85
(defclass-widget-register bounded-float-text(%bounded-float)
  ((disabled :initarg :disabled :accessor disabled
	     :type bool
	     :initform :false
	     :metadata (:sync t
			      :json-name "disabled"
			      :help "Enable or disable user changes"))
   (continuous-update :initarg :continuous-update :accessor continuous-update
		      :type bool
		      :initform :false
		      :metadata (:sync t
				       :json-name "continuous_update"
				       :help "Update the value as the user types. IF False, update on submission, e.g., pressing Enter or navigating away."))
   (step :initarg :step :accessor step
	  :type float
	  :initform 0.1
	  :metadata (:sync t
			   :json-name "step"
			   :help "Minimum step to increment the value"))
   )
  (:default-initargs
   :view-name (unicode "FloatTextView")
    :model-name (unicode "BoundedFloatTextModel"))
  (:metaclass traitlets:traitlet-class))


;;https://github.com/drmeister/widget-dev/blob/master/ipywidgets6/widgets/widget_float.py#L108
(defclass-widget-register float-slider(%bounded-float)
  ((orientation :initarg :orientation :accessor orientation
		:type unicode
		:initform (unicode "horizontal")
		:metadata (:sync t
				 :json-name "orientation"
				 :help "vertical or horizontal"))
   (readout :initarg :readout :accessor readout
	    :type bool
	     :initform :true
	     :metadata (:sync t
			      :json-name "readout"
			      :help "Display the current value of the slider next to it"))
   (readout-format :initarg :readout-format :accessor readout-format
		   :type unicode
		   :initform (unicode ".2f")
		   :metadata (:sync t
				    :json-name "readout_format"
				    :help "Format for the readout"))
   (continuous-update :initarg :continuous-update :accessor continuous-update
		      :type bool
		       :initform :true
		       :metadata (:sync t
					:json-name "continuous_update"
					:help "Update the value of the widget as the user is holding the slider."))
    (disabled :initarg :disabled :accessor disabled
	     :type bool
	     :initform :false
	     :metadata (:sync t
			      :json-name "disabled"
			      :help "Enable or disable user changes"))
   (step :initarg :step :accessor step
	  :type float
	  :initform 0.1
	  :metadata (:sync t
			   :json-name "step"
			   :help "Minimum step to increment the value"))
   )
  (:default-initargs
   :view-name (unicode "FloatSliderView")
    :model-name (unicode "FloatSliderModel"))
  (:metaclass traitlets:traitlet-class))


#|| TODO
@register
class FloatLogSlider(_BoundedLogFloat):
    """ Slider/trackbar of logarithmic floating values with the specified range.

    Parameters
    ----------
    value : float
        position of the slider
    base : float
        base of the logarithmic scale. Default is 10
    min : float
        minimal position of the slider in log scale, i.e., actual minimum is base ** min
    max : float
        maximal position of the slider in log scale, i.e., actual maximum is base ** max
    step : float
        step of the trackbar, denotes steps for the exponent, not the actual value
    description : str
        name of the slider
    orientation : {'horizontal', 'vertical'}
        default is 'horizontal', orientation of the slider
    readout : {True, False}
        default is True, display the current value of the slider next to it
    readout_format : str
        default is '.3g', specifier for the format function used to represent
        slider value for human consumption, modeled after Python 3's format
        specification mini-language (PEP 3101).
    """
    _view_name = Unicode('FloatLogSliderView').tag(sync=True)
    _model_name = Unicode('FloatLogSliderModel').tag(sync=True)
    step = CFloat(0.1, help="Minimum step in the exponent to increment the value").tag(sync=True)
    orientation = CaselessStrEnum(values=['horizontal', 'vertical'],
        default_value='horizontal', help="Vertical or horizontal.").tag(sync=True)
    readout = Bool(True, help="Display the current value of the slider next to it.").tag(sync=True)
    readout_format = NumberFormat(
        '.3g', help="Format for the readout").tag(sync=True)
    continuous_update = Bool(True, help="Update the value of the widget as the user is holding the slider.").tag(sync=True)
    disabled = Bool(False, help="Enable or disable user changes").tag(sync=True)
    base = CFloat(10., help="Base for the logarithm").tag(sync=True)

    style = InstanceDict(SliderStyle).tag(sync=True, **widget_serialization)

||#

;;https://github.com/drmeister/widget-dev/blob/master/ipywidgets6/widgets/widget_float.py#L148
(defclass-widget-register float-progress (%bounded-float)
  ((orientation :initarg :orientation :accessor orientation
		 :type unicode
		 :initform (unicode "horizontal")
		 :metadata (:sync t
				  :json-name "orientation"
				  :help "vertical or horizontal."))
   (bar-style :initarg :bar-style :accessor bar-style
	       :type unicode
	       :initform (unicode "")
	       :metadata (:sync t
				:json-name "bar_style"
				:help "Use a predefined styling for the progress bar. Options: 'success', 'info', 'warning', 'danger'"))
   )
  (:default-initargs
   :view-name (unicode "ProgressView")
    :model-name (unicode "FloatProgressModel"))
  (:metaclass traitlets:traitlet-class))


;;https://github.com/drmeister/widget-dev/blob/master/ipywidgets6/widgets/widget_float.py#L180
(defclass %float-range (description-widget value-widget core-widget)
  ((value :initarg :value :accessor value
	  :type vector
	  :initform (vector 0.0 1.0)
	  ;:validator validate-float-range FIXME
	  :metadata (:sync t
			   :json-name "value"
			   :help "Tuple of (lower, upper) bounds")))
  (:metaclass traitlets:traitlet-class))


;;https://github.com/drmeister/widget-dev/blob/master/ipywidgets6/widgets/widget_float.py#L208
(defclass %bounded-float-range(%float-range)
  ((step :initarg :step :accessor step
	  :type float
	  :initform 1.0
	  :metadata (:sync t
			   :json-name "step"
			   :help "Minimum step that the value can take (ignored by some views)"))
   (value :validator validate-float-bounded-range)
   (max :initarg :max :accessor max
	 :type float
	 :initform 100.0
	 :validator validate-float-max
	 :metadata (:sync t
			  :json-name "max"
			  :help "Max value"))
   (min :initarg :min :accessor min
	 :type float
	 :initform 0.0
	 :validator validate-float-min
	 :metadata (:sync t
			  :json-name "min"
			  :help "Min value"))
   )
  (:metaclass traitlets:traitlet-class))


;;;Validator for range in a bounded float widget
(defun validate-float-bounded-range (object val)
  (flet ((enforce-min (val min) (if (< val min) min val))
	 (enforce-max (val max) (if (> val max) max val)))
    (let ((low-val (cl:min (elt val 0) (elt val 1)))
	  (high-val (cl:max (elt val 0) (elt val 1))))
      ;; Now low-val <= high-val
      (if (and (slot-boundp object 'min) (slot-boundp object 'max))
	  (let ((min (min object))
		(max (max object)))
	    (let ((low-val-min (enforce-min low-val min))
		  (high-val-min (enforce-min high-val min)))
	      (let ((low-val-min-max (enforce-max low-val-min max))
		    (high-val-min-max (enforce-max high-val-min max)))
		(vector low-val-min-max high-val-min-max))))
	  (vector low-val high-val)))))

;;https://github.com/drmeister/widget-dev/blob/master/ipywidgets6/widgets/widget_float.py#L243
(defclass-widget-register float-range-slider(%bounded-float-range)
  ((orientation :initarg :orientation :accessor orientation
		 :type unicode
		 :initform (unicode "horizontal")
		 :metadata (:sync t
				  :json-name "orientation"
				  :help "Vertical or horizontal"))
   (readout :initarg :readout :accessor readout
	     :type bool
	     :initform :true
	     :metadata (:sync t
			      :json-name "readout"
			      :help "Display the current value of the slider next to it"))
   (readout-format :initarg :readout-format :accessor readout-format
		    :type unicode
		    :initform (unicode ".2f")
		    :metadata (:sync t
				     :json-name "readout_format"
				     :help "Format for the readout"))
   (continuous-update :initarg :continuous-update :accessor continuous-update
		       :type bool
		       :initform :true
		       :metadata (:sync t
					:json-name "continuous_update"
				        :help "Update the value of the widget as the user is sliding the slider"))
   (disabled :initarg :disabled :accessor disabled
	     :type bool
	     :initform :false
	     :metadata (:sync t
			      :json-name "disabled"
			      :help "Enable or disabled user changes"))
   )
  (:default-initargs
   :view-name (unicode "FloatRangeSliderView")
    :model-name (unicode "FloatRangeSliderModel"))
  (:metaclass traitlets:traitlet-class))

;;;Validator for min in a ranged float
;;;Make sure the min doesn't exceed the max, and
;;;if the value is below the min, set value to new min.
(defun validate-float-min (object val)
  (if (slot-boundp object 'min)
      (with-slots ((max max) (value value)) object
	(cond ((> val  max) max)
	      ((> val value) (setf value val))
	      (t val))
	val)))

;;;Validator for max in a ranged float
;;;Make sure the max doesn't go below the min, and
;;;if the value is above the max, set value to new max.
(defun validate-float-max (object val)
  (if (slot-boundp object 'max)
      (with-slots ((min min) (value value)) object
	(cond ((> value  val) (setf value val))
	      ((< val min) min)
	      (t val))
	val)))
