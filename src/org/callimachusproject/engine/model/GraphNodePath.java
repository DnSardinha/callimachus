/*
   Copyright (c) 2014 3 Round Stones Inc, Some Rights Reserved

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

 */
package org.callimachusproject.engine.model;

/**
 * SPARQL variable, RDF term, or Path
 * 
 * @author James Leigh
 *
 */
public interface GraphNodePath {

	boolean isNode();

	boolean isIRI();

	boolean isReference();

	boolean isCURIE();

	boolean isPlainLiteral();

	boolean isLiteral();

	boolean isXMLLiteral();

	boolean isTerm();

	boolean isVar();

	Var asVar();

	Reference asReference();

	CURIE asCURIE();

	PlainLiteral asPlainLiteral();

	Literal asLiteral();

	XMLLiteral asXMLLiteral();

	String stringValue();
	
	void setOrigin(TermOrigin origin);
	
	TermOrigin getOrigin();



}