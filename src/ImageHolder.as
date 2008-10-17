﻿/** -----------------------------------------------------------* Image Holder* -----------------------------------------------------------* Description: Loads the images* - ---------------------------------------------------------* Created by: chrisaiv@gmail.com* Modified by: * Date Modified: September 10, 2008* - ---------------------------------------------------------* Copyright ©2008 * - ---------------------------------------------------------***/package src{	import fl.controls.Label;	import flash.net.URLRequest;	import flash.events.*;	import flash.geom.Point;	import flash.text.TextFormat;	import flash.display.Bitmap;	import flash.display.Loader;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.display.Stage;	import flash.system.LoaderContext;	import flash.system.ApplicationDomain;	import flash.system.SecurityDomain;	import gs.TweenLite;	//import gs.TweenLite;	public class ImageHolder extends Sprite	{		private var context:LoaderContext = new LoaderContext();		private var contentLoaded:uint;		private var imgLoader1:Loader = new Loader();		private var imgLoader2:Loader = new Loader();		private var tf:TextFormat;		private var imgData:Array;		private var containerMC:MovieClip;		private var captionTXT:Label;		private var imgMask:Sprite;		private var currentIndex:uint;		private var _stage:Stage;		public function ImageHolder( xmlData:Array, containerMC:MovieClip, captionTXT:Label, stage:Stage, currentImage:Number  )		{			this.imgData = xmlData;			this.containerMC = containerMC;			this._stage = stage;			this.captionTXT = captionTXT;			//Style the Caption Box			tf = new TextFormat();			tf.size = 25;			tf.font = "Times";			tf.color = 0xFFFFFF;			this.captionTXT.setStyle("textFormat", tf);			//Get the proper access needed to load images			context.checkPolicyFile = true;			//If you're doing some local Testing, this might needs this			//context.applicationDomain = ApplicationDomain.currentDomain;						//If we are not on a domain authorized by te cross policy file, allow the SWF to catch the error//			context.securityDomain = SecurityDomain.currentDomain;						loadImage( currentImage );			buildMask();		}				public function loadImage( index:uint ):void		{			currentIndex = index;			var imgURL:String = imgData[currentIndex].src;									//Load the Images + Handle most of the Events			enableBasicListeners( imgLoader1.contentLoaderInfo );			enableBasicListeners( imgLoader2.contentLoaderInfo );							if (contentLoaded == 1)				imgLoader2.load( new URLRequest( imgURL ), context );			else				imgLoader1.load( new URLRequest( imgURL ), context );					}				private function enableBasicListeners(dispatcher:IEventDispatcher):void		{			dispatcher.addEventListener( Event.COMPLETE, showImageLoaded, false, 0, true );			dispatcher.addEventListener( ProgressEvent.PROGRESS, showImageProgress, false, 0, true );			dispatcher.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true );			dispatcher.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true );				dispatcher.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true );		}		private function disableBasicListeners(dispatcher:IEventDispatcher):void		{			dispatcher.removeEventListener( Event.COMPLETE, showImageLoaded );			dispatcher.removeEventListener( ProgressEvent.PROGRESS, showImageProgress );			dispatcher.removeEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );			dispatcher.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );				dispatcher.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );		}						private function buildMask():void		{			imgMask = new Sprite();				imgMask.graphics.beginFill (0xFFFFFF);			imgMask.graphics.drawRect (0, 0, containerMC.width, containerMC.height);			imgMask.graphics.endFill ();			containerMC.addChild(imgMask);			containerMC.mask = imgMask;		}				private function centerBitmap( bmp:Bitmap ):void		{			bmp.x = getCenterPoint().x - (bmp.width / 2);			bmp.y = (getCenterPoint().y) - (bmp.height / 2);			}		private function getCenterPoint():Point		{			//var center:Point = new Point(_stage.stageWidth / 2, _stage.stageHeight / 2);			var center:Point = new Point( containerMC.width / 2, containerMC.height / 2);			return center;		}				private function showImageLoaded( e:Event ):void		{			var currentLoader:Loader = Loader( e.currentTarget.loader );				//Drop the Alpha of the Image so that I can tween 				currentLoader.alpha = 0;			var bmp:Bitmap = e.currentTarget.content as Bitmap;				//Center the Bitmap Image				centerBitmap( bmp );						//Fade out the Previous Image			var prevLoader:String = currentLoader.name.substring(0, (currentLoader.name.length - 1)) + contentLoaded;			TweenLite.to( containerMC.getChildByName(prevLoader), 0.4, {alpha:0, onUpdate:onProgressUpdate, onUpdateParams:[containerMC.getChildByName(prevLoader)] } );			//This Toggle between which Image Loader to use			if (contentLoaded == 1) contentLoaded = 2;			else contentLoaded = 1;						//Add the Image to the Container MovieClip			containerMC.addChild(currentLoader);			//Tweeen in the Image			TweenLite.to( currentLoader, 0.5, {alpha:1, onStart:updateCaption} );		}				private function updateCaption():void		{			//Update the Caption			captionTXT.text = imgData[currentIndex].caption;;		}				private function onProgressUpdate( l:Loader ):void		{			//trace( "Previous Loader.alpha: " + l.alpha );		}		private function showImageProgress( e:ProgressEvent ):void		{			//captionTXT.text = Math.floor( e.bytesLoaded / e.bytesTotal * 100) + "%" ;		}		private function httpStatusHandler (e:HTTPStatusEvent):void		{			//captionTXT.text = ("httpStatusHandler:" + e).toString();		}				private function securityErrorHandler (e:SecurityErrorEvent):void		{			captionTXT.text = ("securityErrorHandler:" + e).toString();		}				private function ioErrorHandler(e:IOErrorEvent):void		{			captionTXT.text = ("ioErrorHandler: " + e).toString();		}			}}