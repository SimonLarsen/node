default: love

.PHONY: love
love:
	zip -r node-$$(date +%F-%H%M).love *
